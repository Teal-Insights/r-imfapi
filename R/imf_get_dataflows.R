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
#' \dontrun{
#' imf_get_dataflows()
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
      id = dataflow$id[[1]],
      name = dataflow$name[[1]],
      description = dataflow$description[[1]],
      version = dataflow$version[[1]],
      agency = dataflow$agencyID[[1]],
      structure = dataflow$structure[[1]],
      last_updated = dataflow$annotations[[which(
        vapply(
          dataflow$annotations,
          function(x) "lastUpdatedAt" %in% x$id, logical(1)
        )
      )]]$value[[1]]
    )
  })
}
