#' Retrieve codes for one or more dimensions as a tidy tibble
#'
#' Returns a tibble mapping dimensions to their codes and labels by fetching the
#' corresponding codelists. By convention, codelist IDs are assumed to be
#' `CL_{dimension_id}` for first-pass coverage.
#'
#' @param dimension_ids Character vector of dimension IDs (e.g., "COUNTRY").
#' @param dataflow_id Character scalar. The dataflow whose datastructure is
#'   used to resolve each dimension's codelist via its concept scheme reference.
#' @param progress Logical; whether to show progress.
#' @param max_tries Integer; maximum retry attempts.
#' @param cache Logical; whether to cache requests.
#'
#' @return tibble::tibble(
#'   dimension_id = character(),
#'   code = character(),
#'   name = character(),
#'   description = character(),
#'   codelist_id = character(),
#'   codelist_agency = character(),
#'   codelist_version = character()
#' )
#'
#' @examples
#' \dontrun{
#' imf_get_codelists(c("FREQUENCY", "TIME_PERIOD"))
#' }
#' @export
imf_get_codelists <- function(
  dimension_ids,
  dataflow_id,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE
) {
  # Validate arguments
  if (!is.character(dimension_ids) || length(dimension_ids) < 1L) {
    cli::cli_abort("{.arg dimension_ids} must be a non-empty character vector.")
  }
  if (any(is.na(dimension_ids) | !nzchar(trimws(dimension_ids)))) {
    cli::cli_abort(
      "{.arg dimension_ids} must not contain missing/empty values."
    )
  }
  if (
    !is.character(dataflow_id) || length(dataflow_id) != 1L ||
      is.na(dataflow_id) || !nzchar(trimws(dataflow_id))
  ) {
    cli::cli_abort(
      "{.arg dataflow_id} must be a non-empty character scalar."
    )
  }

  # Normalize inputs
  dimension_ids <- unique(trimws(as.character(dimension_ids)))

  # Fetch DSD components via helper
  components <- get_datastructure_components(
    dataflow_id = dataflow_id,
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )

  # Build local map from dimension id -> conceptIdentity and local enumeration
  dims <- c(
    components[["dimensionList"]][["dimensions"]],
    components[["dimensionList"]][["timeDimensions"]]
  )
  dims <- dims[!vapply(dims, is.null, logical(1))]
  dim_map <- purrr::map(dims, function(x) {
    list(
      id = first_scalar(x$id),
      concept_identity = first_scalar(x$conceptIdentity),
      local_enum = first_scalar(tryCatch(
        x$localRepresentation$enumeration,
        error = function(e) NULL
      ))
    )
  })
  names(dim_map) <- vapply(dim_map, function(x) x$id, character(1))

  # Resolve per requested dimension id
  resolved <- purrr::map(dimension_ids, function(did) {
    entry <- dim_map[[did]]
    if (is.null(entry)) return(NULL)
    cref <- parse_concept_urn(entry$concept_identity)
    # Fetch concept scheme (try agency, then all)
    cs_paths <- c(
      sprintf("structure/conceptscheme/%s/%s/+", cref$agency, cref$scheme),
      sprintf("structure/conceptscheme/all/%s/+", cref$scheme)
    )
    cs_body <- NULL
    # Try agency path first, then fallback to all/* if that 404s
    for (p in cs_paths) {
      cs_body <- tryCatch(
        perform_request(
          p,
          progress = progress,
          max_tries = max_tries,
          cache = cache
        ),
        error = function(e) NULL
      )
      if (!is.null(cs_body)) break
    }
    if (is.null(cs_body)) {
      cli::cli_abort(
        "Conceptscheme not found for {cref$scheme} (agency {cref$agency})."
      )
    }
    cs_list <- cs_body[["data"]][["conceptSchemes"]]
    concept <- NULL
    if (!is.null(cs_list)) {
      for (cs in cs_list) {
        cands <- cs$concepts
        if (is.null(cands)) next
        found <- purrr::keep(
          cands,
          function(cn) identical(first_scalar(cn$id), cref$concept)
        )
        if (length(found) == 1) {
          concept <- found[[1]]
          break
        }
      }
    }
    enum_from_concept <- first_scalar(concept$coreRepresentation$enumeration)
    enum_urn <- if (!is.na(enum_from_concept) && nzchar(enum_from_concept)) {
      enum_from_concept
    } else {
      entry$local_enum
    }
    if (is.na(enum_urn) || !nzchar(enum_urn)) return(NULL)
    cl <- parse_codelist_urn(enum_urn)
    # Fetch codelist
    cl_paths <- c(
      sprintf("structure/codelist/%s/%s/+", cl$agency, cl$id),
      sprintf("structure/codelist/all/%s/+", cl$id)
    )
    cl_body <- NULL
    # Try agency-qualified codelist first; if it fails, try global
    for (p in cl_paths) {
      cl_body <- tryCatch(
        perform_request(
          p,
          progress = progress,
          max_tries = max_tries,
          cache = cache
        ),
        error = function(e) NULL
      )
      if (!is.null(cl_body)) break
    }
    if (is.null(cl_body)) {
      cli::cli_abort(
        "Codelist {cl$id} not found (agency {cl$agency})."
      )
    }
    clists <- cl_body[["data"]][["codelists"]]
    if (is.null(clists) || length(clists) < 1) {
      cli::cli_abort("Empty codelists payload for {cl$id}.")
    }
    codes <- clists[[1]]$codes
    if (is.null(codes)) {
      cli::cli_abort("No codes found in codelist {cl$id}.")
    }
    purrr::map_dfr(codes, function(cd) {
      tibble::tibble(
        dimension_id = did,
        code = first_scalar(cd$id),
        name = first_scalar(cd$name),
        description = first_scalar(cd$description),
        codelist_id = cl$id,
        codelist_agency = cl$agency,
        codelist_version = cl$version
      )
    })
  })
  out <- dplyr::bind_rows(resolved)
  out
}