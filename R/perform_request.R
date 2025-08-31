#' @keywords internal
#' @noRd
#'
perform_request <- function(
  resource,
  progress = FALSE,
  max_tries = 10L
  # TODO: Cache control pass-through argument here?
) {
  # TODO: Argument validation here?

  base_url <- "https://api.imf.org/external/sdmx/3.0/"

  # Create the request
  request <- httr2::request(base_url) |>
    httr2::req_url_path_append(resource) |>
    httr2::req_headers(
      "Accept" = "application/json",
      "User-Agent" = "imf R package (https://github.com/teal-insights/r-imf)"
    ) |>
    httr2::req_cache(tempdir()) |>
    httr2::req_retry(max_tries = max_tries)

  # Execute the request
  response <- request |>
    httr2::req_perform()

  # Check for status error
  if (httr2::resp_status(response) >= 400) {
    stop("Request failed with status ", httr2::resp_status(response))
  }

  body <- httr2::resp_body_json(response)

  body
}