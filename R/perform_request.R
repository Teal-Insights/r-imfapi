#' @keywords internal
#' @noRd
#'
perform_request <- function(
  resource,
  per_page = 15000L,
  progress = FALSE,
  max_tries = 10L
  # TODO: Cache control pass-through argument here?
) {
  # TODO: Argument validation here?

  base_url <- "https://api.imf.org/external/sdmx/3.0"

  # Create and execute the request
  # TODO: add retry
  response <- httr2::request(paste0(base_url, resource)) |>
    httr2::req_headers(
      "Accept" = "application/json",
      "User-Agent" = "imf/0.0.0.1 R client"
    ) |>
    httr2::req_cache(tempdir()) |>
    httr2::req_perform()

  return(response)
}