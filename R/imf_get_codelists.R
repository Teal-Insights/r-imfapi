#' Retrieve codes for one or more dimensions as a tidy tibble
#'
#' Returns a tibble mapping dimensions to their codes and labels by fetching the
#' corresponding codelists. By convention, codelist IDs are assumed to be
#' `CL_{dimension_id}` for first-pass coverage.
#'
#' @param dimension_ids Character vector of dimension IDs (e.g., "COUNTRY").
#' @param dataflow_id Optional character scalar. If provided, traverse the
#'   dataflow's datastructure to resolve each dimension's codelist via its
#'   concept scheme reference. If omitted, falls back to `CL_{dimension}` lookup
#'   across all agencies.
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
  dataflow_id = NULL,
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

  # Normalize inputs
  dimension_ids <- unique(trimws(as.character(dimension_ids)))

  # Helper: parsers and safe fetchers
  first_scalar <- function(x) {
    if (is.null(x)) return(NA_character_)
    if (is.list(x)) x <- unlist(x, use.names = FALSE, recursive = TRUE)
    if (length(x) == 0) return(NA_character_)
    as.character(x[[1]])
  }
  parse_concept_urn <- function(urn) {
    m <- regexec(
      paste0(
        "^urn:sdmx:org\\.sdmx\\.infomodel\\.conceptscheme\\.Concept=",
        "([^:]+):([^\\(]+)\\(([^\\)]+)\\)\\.(.+)$"
      ),
      first_scalar(urn)
    )
    p <- regmatches(first_scalar(urn), m)[[1]]
    if (length(p) == 5) {
      list(
        agency = p[2],
        scheme = p[3],
        version = p[4],
        concept = p[5]
      )
    } else {
      list(
        agency = NA_character_,
        scheme = NA_character_,
        version = NA_character_,
        concept = NA_character_
      )
    }
  }
  parse_codelist_urn <- function(urn) {
    m <- regexec(
      paste0(
        "^urn:sdmx:org\\.sdmx\\.infomodel\\.codelist\\.(?:CodeList|Codelist)=",
        "([^:]+):([^\\(]+)\\(([^\\)]+)\\)$"
      ),
      first_scalar(urn)
    )
    p <- regmatches(first_scalar(urn), m)[[1]]
    if (length(p) == 4) {
      list(agency = p[2], id = p[3], version = p[4])
    } else {
      list(agency = NA_character_, id = NA_character_, version = NA_character_)
    }
  }
  safe_request <- function(path, ...) {
    tryCatch({
      perform_request(path, ...)
    }, error = function(e) NULL)
  }

  # If a dataflow is provided, resolve dimension -> concept -> codelist
  if (!is.null(dataflow_id)) {
    if (
      !is.character(dataflow_id) || length(dataflow_id) != 1L ||
        is.na(dataflow_id) || !nzchar(trimws(dataflow_id))
    ) {
      cli::cli_abort(paste0(
        "{.arg dataflow_id} must be a non-empty character scalar ",
        "if provided."
      ))
    }

    # Fetch DSD
    dsd_path <- sprintf("structure/datastructure/all/DSD_%s/+", dataflow_id)
    dsd_body <- safe_request(
      dsd_path,
      progress = progress,
      max_tries = max_tries,
      cache = cache
    )
    if (is.null(dsd_body)) {
      # Discover DSD via dataflow
      df_body <- safe_request(
        sprintf("structure/dataflow/all/%s/+", dataflow_id),
        progress = progress,
        max_tries = max_tries,
        cache = cache
      )
      dsd_urn <- tryCatch(
        df_body[["data"]][["dataflows"]][[1]][["structure"]],
        error = function(e) NULL
      )
      dsd_parts <- tryCatch({
        m <- regexec(
          paste0(
            "^urn:sdmx:org\\.sdmx\\.infomodel\\.datastructure\\.DataStructure=",
            "([^:]+):([^\\(]+)\\(([^\\)]+)\\)$"
          ),
          first_scalar(dsd_urn)
        )
        regmatches(first_scalar(dsd_urn), m)[[1]]
      }, error = function(e) NULL)
      if (!is.null(dsd_parts) && length(dsd_parts) == 4) {
        dsd_body <- safe_request(
          sprintf(
            "structure/datastructure/%s/%s/+", dsd_parts[2], dsd_parts[3]
          ),
          progress = progress,
          max_tries = max_tries,
          cache = cache
        )
      }
    }
    components <- tryCatch(
      dsd_body[["data"]][["dataStructures"]][[1]][["dataStructureComponents"]],
      error = function(e) NULL
    )
    if (is.null(components)) return(NULL)

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
      for (p in cs_paths) {
        cs_body <- safe_request(
          p,
          progress = progress,
          max_tries = max_tries,
          cache = cache
        )
        if (!is.null(cs_body)) break
      }
      cs_list <- tryCatch(
        cs_body[["data"]][["conceptSchemes"]],
        error = function(e) NULL
      )
      concept <- NULL
      if (!is.null(cs_list)) {
        for (cs in cs_list) {
          cands <- tryCatch(cs$concepts, error = function(e) NULL)
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
      enum_from_concept <- first_scalar(tryCatch(
        concept$coreRepresentation$enumeration,
        error = function(e) NULL
      ))
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
      for (p in cl_paths) {
        cl_body <- safe_request(
          p,
          progress = progress,
          max_tries = max_tries,
          cache = cache
        )
        if (!is.null(cl_body)) break
      }
      clists <- tryCatch(
        cl_body[["data"]][["codelists"]],
        error = function(e) NULL
      )
      if (is.null(clists) || length(clists) < 1) return(NULL)
      codes <- tryCatch(clists[[1]]$codes, error = function(e) NULL)
      if (is.null(codes)) return(NULL)
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
    return(out)
  }

  # Legacy fallback: assume CL_{dimension} across all
  codelist_ids <- paste0("CL_", dimension_ids)
  resource_path <- paste0(
    "structure/codelist/all/",
    paste(codelist_ids, collapse = ","),
    "/+"
  )
  body <- perform_request(
    resource_path,
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )
  codelists <- tryCatch(body[["data"]][["codelists"]], error = function(e) NULL)
  codelists
}