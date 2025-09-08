#' Retrieve the datastructure definition for an IMF dataflow.
#'
#' @param dataflow_id The ID of the dataflow to retrieve the datastructure for.
#' @param progress Logical; whether to show progress.
#' @param max_tries Integer; maximum retry attempts.
#' @param cache Logical; whether to cache the request.
#'
#' @return data.frame(
#'   dimension_id = character(),
#'   order = integer(),
#'   concept_id = character(),
#'   concept_name = character(),
#'   role = character(),
#'   codelist_id = character(),
#'   codelist_agency = character(),
#'   representation_type = character(),
#'   stringsAsFactors = FALSE
#' )
#'
#' @examples
#' \dontrun{
#' imf_get_datastructure("GFS")
#' }
#' @export
imf_get_datastructure <- function(
  dataflow_id,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE
) {
  structure_path <- sprintf(
    "structure/datastructure/IMF.STA/DSD_%s/+", dataflow_id
  )
  body <- imf_perform_request(
    structure_path,
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )
  # Helpers for safe extraction
  first_non_null <- function(...) {
    args <- list(...)
    for (val in args) {
      if (!is.null(val) && length(val) > 0) return(val)
    }
    NULL
  }
  as_scalar_chr <- function(x) {
    if (is.null(x)) return(NA_character_)
    if (is.list(x)) {
      # Prefer first element if list (e.g., multilingual name list)
      x <- x[[1]]
    }
    if (length(x) == 0) return(NA_character_)
    as.character(x[[1]])
  }

  # Navigate to components → dimensions (defensively, SDMX 3.0 JSON may vary)
  data_structure <- tryCatch(
    body[["data"]][["dataStructures"]][[1]],
    error = function(e) NULL
  )
  components <- tryCatch(
    data_structure[["dataStructureComponents"]],
    error = function(e) NULL
  )

  # Try common locations for the dimensions list
  dimensions_list <- first_non_null(
    tryCatch(
      purrr::pluck(components, "dimensionList", "dimensions"),
      error = function(e) NULL
    ),
    tryCatch(purrr::pluck(components, "dimensions"), error = function(e) NULL)
  )

  # If dimensions are missing, return empty data.frame with the right columns
  if (is.null(dimensions_list) || length(dimensions_list) == 0) {
    return(data.frame(
      dimension_id = character(),
      order = integer(),
      concept_id = character(),
      concept_name = character(),
      role = character(),
      codelist_id = character(),
      codelist_agency = character(),
      representation_type = character(),
      stringsAsFactors = FALSE
    ))
  }

  rows <- lapply(seq_along(dimensions_list), function(idx) {
    dim_obj <- dimensions_list[[idx]]

    # IDs
    dimension_id <- as_scalar_chr(dim_obj$id)

    # Concept metadata (ID + Name)
    concept_id <- as_scalar_chr(first_non_null(
      tryCatch(
        purrr::pluck(dim_obj, "conceptIdentity", "id"), error = function(e) NULL
      ),
      tryCatch(
        purrr::pluck(dim_obj, "concept", "id"), error = function(e) NULL
      )
    ))
    concept_name <- as_scalar_chr(first_non_null(
      tryCatch(
        purrr::pluck(dim_obj, "conceptIdentity", "name"),
        error = function(e) NULL
      ),
      tryCatch(
        purrr::pluck(dim_obj, "concept", "name"), error = function(e) NULL
      )
    ))

    # Role: attempt explicit role, then infer from id
    role_raw <- as_scalar_chr(first_non_null(
      tryCatch(purrr::pluck(dim_obj, "role", "id"), error = function(e) NULL),
      tryCatch(purrr::pluck(dim_obj, "role"), error = function(e) NULL)
    ))
    role_val <- if (
      !is.na(role_raw) && grepl("time", tolower(role_raw), fixed = TRUE)
    ) {
      "time"
    } else if (
      !is.na(dimension_id) &&
        toupper(dimension_id) %in% c("TIME", "TIME_PERIOD")
    ) {
      "time"
    } else if (
      !is.na(concept_id) && toupper(concept_id) %in% c("TIME", "TIME_PERIOD")
    ) {
      "time"
    } else {
      NA_character_
    }

    # Representation: codelist (enumeration) vs text/number
    enum_node <- first_non_null(
      tryCatch(
        purrr::pluck(dim_obj, "localRepresentation", "enumeration"),
        error = function(e) NULL
      )
    )
    codelist_id <- as_scalar_chr(first_non_null(
      if (!is.null(enum_node)) tryCatch(
        enum_node$id, error = function(e) NULL
      ) else NULL,
      if (!is.null(enum_node)) tryCatch(
        purrr::pluck(enum_node, "ref", "id"), error = function(e) NULL
      ) else NULL
    ))
    codelist_agency <- as_scalar_chr(first_non_null(
      if (!is.null(enum_node)) tryCatch(
        enum_node$agencyID, error = function(e) NULL
      ) else NULL,
      if (!is.null(enum_node)) tryCatch(
        purrr::pluck(enum_node, "ref", "agencyID"), error = function(e) NULL
      ) else NULL
    ))
    text_fmt_node <- first_non_null(
      tryCatch(
        purrr::pluck(dim_obj, "localRepresentation", "textFormat"),
        error = function(e) NULL
      ),
      tryCatch(
        purrr::pluck(dim_obj, "localRepresentation", "textRepresentation"),
        error = function(e) NULL
      )
    )
    value_type <- as_scalar_chr(first_non_null(
      if (!is.null(text_fmt_node)) tryCatch(
        purrr::pluck(text_fmt_node, "valueType"), error = function(e) NULL
      ) else NULL,
      if (!is.null(text_fmt_node)) tryCatch(
        purrr::pluck(text_fmt_node, "type"), error = function(e) NULL
      ) else NULL
    ))
    representation_type <- if (!is.na(codelist_id)) {
      "codelist"
    } else if (!is.na(value_type)) {
      value_type
    } else {
      NA_character_
    }

    data.frame(
      dimension_id = as_scalar_chr(dimension_id),
      order = as.integer(idx),
      concept_id = as_scalar_chr(concept_id),
      concept_name = as_scalar_chr(concept_name),
      role = role_val,
      codelist_id = as_scalar_chr(codelist_id),
      codelist_agency = as_scalar_chr(codelist_agency),
      representation_type = as_scalar_chr(representation_type),
      stringsAsFactors = FALSE
    )
  })

  purrr::map_dfr(rows, function(x) x)
}
