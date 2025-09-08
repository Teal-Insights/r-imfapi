## Retrieve codes for one or more dimensions as a tidy tibble (internal)
#'
#' Returns a tibble mapping dimensions to their codes and labels by fetching the
#' corresponding codelists. By convention, codelist IDs are assumed to be
#' `CL_{dimension_id}` for first-pass coverage.
#'
#' @param dimension_ids Character vector of dimension IDs (e.g., "COUNTRY").
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
  codelist_ids <- paste0("CL_", dimension_ids)
  # Note: IMF.STA owns dataflows, but IMF owns codelists
  resource_path <- paste0(
    "structure/codelist/IMF/", paste(codelist_ids, collapse = "+"), "/+"
  )

  body <- imf_perform_request(
    resource_path, progress = progress, max_tries = max_tries, cache = cache
  )

  codelists <- tryCatch(
    body[["data"]][["codelists"]], error = function(e) NULL
  )

  codelists
}