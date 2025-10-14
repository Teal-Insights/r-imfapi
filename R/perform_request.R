#' @keywords internal
#' @noRd
#'
perform_request <- function(
  resource,
  progress = FALSE,
  base_url = "https://api.imf.org/external/sdmx/3.0/",
  query_params = NULL,
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

  if (!is.null(query_params)) {
    request <- request |>
      httr2::req_url_query(!!!query_params)
  }

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
  status_code <- httr2::resp_status(response)
  if (status_code >= 400) {
    body_txt <- httr2::resp_body_string(response)
    parsed <- NULL
    msg <- NULL
    code <- NULL
    corr <- NULL
    path <- NULL
    try({
      parsed <- jsonlite::fromJSON(body_txt)
      msg <- parsed$message
      code <- parsed$code
      corr <- parsed$correlationId
      path <- parsed$path
    }, silent = TRUE)
    if (!nzchar(msg)) msg <- "HTTP error"
    detail <- paste0(
      "status=", status_code,
      if (!is.null(code)) paste0(" code=", code) else "",
      if (!is.null(corr)) paste0(" correlationId=", corr) else "",
      if (!is.null(path)) paste0(" path=", path) else "",
      " resource=", resource
    )
    cli::cli_abort(paste(msg, detail))
  }

  # Parse successful response; ensure JSON or provide helpful error
  ct <- httr2::resp_header(response, "content-type")
  if (!is.null(ct) && grepl("json", ct, ignore.case = TRUE)) {
    body <- httr2::resp_body_json(response)
    return(body)
  }

  # Fallback: attempt JSON parse from text, else show content-type/body snippet
  body_txt <- httr2::resp_body_string(response)
  parsed <- NULL
  ok <- FALSE
  try({
    parsed <- jsonlite::fromJSON(body_txt)
    ok <- TRUE
  }, silent = TRUE)
  if (ok) return(parsed)

  preview <- substr(body_txt, 1L, 300L)
  cli::cli_abort(paste0(
    "Unexpected content type ", shQuote(ifelse(is.null(ct), "(none)", ct)),
    ". Expected JSON. Resource=", resource, ". Body preview: ", preview
  ))

  body
}
