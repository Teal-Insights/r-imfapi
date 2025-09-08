#' @keywords internal
#' @noRd
#'
imf_perform_request <- function(
  resource,
  progress = FALSE,
  base_url = "https://api.imf.org/external/sdmx/3.0/",
  max_tries = 10L,
  cache = TRUE
) {
  # Argument validation
  if (
    !is.character(resource) || length(resource) != 1L ||
      is.na(resource) || !nzchar(trimws(resource))
  ) {
    cli::cli_abort("{.arg resource} must be a non-empty character scalar.")
  }
  if (grepl("^https?://", resource)) {
    cli::cli_abort(
      "{.arg resource} should be a path (e.g., 'structure/'), not a full URL."
    )
  }
  if (!is.logical(progress) || length(progress) != 1L || is.na(progress)) {
    cli::cli_abort("{.arg progress} must be a single non-missing logical.")
  }
  if (!is.logical(cache) || length(cache) != 1L || is.na(cache)) {
    cli::cli_abort("{.arg cache} must be a single non-missing logical.")
  }
  if (
    !is.numeric(max_tries) || length(max_tries) != 1L || is.na(max_tries) ||
      !is.finite(max_tries) || max_tries < 1 ||
      max_tries != as.integer(max_tries)
  ) {
    cli::cli_abort("{.arg max_tries} must be a positive whole number.")
  }
  max_tries <- as.integer(max_tries)

  # Create the request
  request <- httr2::request(base_url) |>
    httr2::req_url_path_append(resource) |>
    httr2::req_headers(
      "Accept" = "application/json",
      "User-Agent" = (
        "imfapi R package (https://github.com/teal-insights/r-imfapi)"
      )
    ) |>
    httr2::req_retry(max_tries = max_tries)

  if (isTRUE(cache)) {
    request <- request |>
      httr2::req_cache(tempdir())
  }

  if (isTRUE(progress)) {
    request <- request |>
      httr2::req_progress()
  }

  # Execute the request
  response <- request |>
    httr2::req_perform()

  # Check for status error
  if (httr2::resp_status(response) >= 400) {
    cli::cli_abort("Request failed with status {httr2::resp_status(response)}")
  }

  body <- httr2::resp_body_json(response)

  body
}