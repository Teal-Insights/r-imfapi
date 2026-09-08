#' Get dataflow definitions for aLL available IMF datasets
#'
#' Retrieves and returns all available dataflow definitions from the SDMX
#' dataflow endpoint.
#'
#' @param progress Logical; whether to show progress.
#' @param max_tries Integer; maximum retry attempts.
#' @param cache Logical; whether to cache the request.
#'
#' @return tibble::tibble(
#'   id = character(),           # e.g., "MFS_IR", "SPE", etc.
#'   name = character(),         # English name
#'   description = character(),  # English description
#'   version = character(),      # e.g., "8.0.1"
#'   structure = character(),    # DSD reference
#'   last_updated = character() # from annotations
#' )
#' @examples
#' \donttest{
#' if (curl::has_internet()) {
#'   imf_get_dataflows()
#' }
#' }
#' @export
imf_get_dataflows <- function(progress = FALSE, max_tries = 10L, cache = TRUE) {
  df <- get_dataflows_components(
    progress = progress, max_tries = max_tries, cache = cache
  )
  # Hide internal foreign key `structure` from the public API
  dplyr::select(df, -structure)
}

#' Retrieve raw dataflows including structure URN (internal)
#'
#' @keywords internal
#' @noRd
get_dataflows_components <- function(
  progress = FALSE, max_tries = 10L, cache = TRUE
) {
  body <- perform_request(
    resource = "structure/dataflow/all/*/+", # '+' = latest stable version
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )

  raw_dataflows <- body[["data"]][["dataflows"]]
  if (is.null(raw_dataflows)) {
    cli::cli_abort("No dataflows found in response.")
  }

  purrr::map_dfr(raw_dataflows, function(dataflow) {
    tibble::tibble(
      id = first_scalar(dataflow$id),
      name = first_scalar(dataflow$name),
      description = first_scalar(dataflow$description),
      version = first_scalar(dataflow$version),
      agency = first_scalar(dataflow$agencyID),
      structure = first_scalar(dataflow$structure),
      last_updated = extract_last_updated(dataflow$annotations)

    )
  })
}

#' Extract the `lastUpdatedAt` annotation value from a list of annotations
#'
#' Returns `NA_character_` when the annotation list is absent or contains no
#' `lastUpdatedAt` entry, rather than erroring.
#'
#' @keywords internal
#' @noRd
extract_last_updated <- function(annotations) {
  if (is.null(annotations) || length(annotations) == 0) {
    return(NA_character_)
  }
  matches <- which(vapply(
    annotations,
    function(x) "lastUpdatedAt" %in% x$id, logical(1)
  ))
  if (length(matches) == 0) {
    return(NA_character_)
  }
  first_scalar(annotations[[matches[[1]]]]$value)
}
