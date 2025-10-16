#' Retrieve data from an IMF dataset
#'
#' Fetches observations for a given `dataflow_id` and `resource_id` from the
#' IMF SDMX 3.0 Data API. The request key is constructed from the dataset's
#' datastructure (DSD) using the positional order of dimensions. Time filtering
#' is applied via query parameters.
#'
#' By default, the request targets the `all` agencies scope for the data path,
#' assuming dataflow IDs are globally unique in practice. The response layout
#' uses a time-series context, and client code will shape the parsed payload
#' into a tidy tibble.
#'
#' @param dataflow_id Character scalar. The dataflow to query (e.g., "GFS").
#' @param dimensions Named list mapping dimension IDs to character vectors of
#'   codes to include. Omitted dimensions are wildcarded in the key. Each
#'   dimension position in the DSD corresponds to one dot-separated slot in the
#'   key; multiple codes per slot are joined by '+'.
#' @param start_period Optional character. Lower bound for time filtering
#'   (e.g., "2000", "2000-Q1", "2000-01").
#' @param end_period Optional character. Upper bound for time filtering, same
#'   format as `start_period`.
#' The request always uses the SDMX 3.0 `dataflow` context under the hood and
#' sets `dimensionAtObservation = "TIME_PERIOD"` to request a time-series view.
#' @param progress Logical; whether to show request progress.
#' @param max_tries Integer; maximum retry attempts for HTTP requests.
#' @param cache Logical; whether to enable caching for HTTP requests.
#'
#' @return A tibble with one row per observation, including dimension columns,
#'   time period, value column(s), and any requested attributes. Exact column
#'   names follow the dataset's DSD and may vary by `dataflow_id`.
#'
#' @details
#' The request key is built by ordering dimensions by their DSD `position` and
#' filling each position with either a '+'-joined set of selected codes or a
#' blank for wildcard. Time filtering is applied via `start_period` and
#' `end_period` query parameters rather than encoding time into the key.
#'
#' @examples
#' if (curl::has_internet()) {
#'   imf_get(
#'     dataflow_id = "FM",  # Fiscal Monitor
#'     dimensions = list(COUNTRY = c("USA", "CAN"))
#'   )
#' }
#' @export
imf_get <- function(
  dataflow_id,
  dimensions = list(),
  start_period = NULL,
  end_period = NULL,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE
) {
  # Validate arguments
  if (
    !is.character(dataflow_id) || length(dataflow_id) != 1L ||
      is.na(dataflow_id) || !nzchar(trimws(dataflow_id))
  ) {
    cli::cli_abort("{.arg dataflow_id} must be a non-empty character scalar.")
  }
  if (!is.list(dimensions)) {
    cli::cli_abort("{.arg dimensions} must be a named list.")
  }
  if (
    length(dimensions) > 0 &&
      (is.null(names(dimensions)) || any(!nzchar(names(dimensions))))
  ) {
    cli::cli_abort(
      "{.arg dimensions} must be a named list with non-empty names."
    )
  }

  # Normalize dimension filters (trim/collapse uniques)
  norm_dims <- lapply(dimensions, function(v) {
    if (is.null(v)) return(character(0))
    v <- as.character(v)
    v <- trimws(v)
    v <- v[nzchar(v) & !is.na(v)]
    unique(v)
  })

  # Fetch DSD components and derive ordered non-time dimensions
  components <- get_datastructure_components(
    dataflow_id = dataflow_id,
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )
  dims <- components[["dimensionList"]][["dimensions"]]
  time_dims <- components[["dimensionList"]][["timeDimensions"]]
  # Build tibble of all dimensions with position; mark time dims
  all_rows <- purrr::map_dfr(dims, function(x) {
    tibble::tibble(
      id = as.character(x$id),
      position = as.integer(x$position),
      type = as.character(x$type)
    )
  })
  if (!is.null(time_dims)) {
    td <- purrr::map_dfr(time_dims, function(x) {
      tibble::tibble(
        id = as.character(x$id),
        position = as.integer(x$position),
        type = as.character(x$type)
      )
    })
    all_rows <- dplyr::bind_rows(all_rows, td)
  }
  # Series key uses non-time dimensions (TIME_PERIOD varies at observation)
  key_rows <- all_rows[all_rows$type != "TimeDimension", , drop = FALSE]
  key_rows <- key_rows[order(key_rows$position), , drop = FALSE]

  # Validate requested dimension names exist
  unknown <- setdiff(names(norm_dims), key_rows$id)
  if (length(unknown) > 0) {
    cli::cli_abort(paste0(
      "Unknown dimension(s) in {.arg dimensions}: ",
      paste(unknown, collapse = ", ")
    ))
  }

  # Build dot-separated key with plus-separated codes per position
  segments <- vapply(key_rows$id, function(dim_id) {
    vals <- norm_dims[[dim_id]]
    if (is.null(vals) || length(vals) == 0) "*" else paste(vals, collapse = "+")
  }, character(1))
  key <- paste(segments, collapse = ".")

  # Build query params
  query <- list(
    dimensionAtObservation = "TIME_PERIOD",
    attributes = "dsd",
    measures = "all"
  )
  # Time filter via c[TIME_PERIOD] parameter if provided
  time_filters <- character(0)
  if (!is.null(start_period)) {
    time_filters <- c(time_filters, paste0("ge:", start_period))
  }
  if (!is.null(end_period)) {
    time_filters <- c(time_filters, paste0("le:", end_period))
  }
  if (length(time_filters) > 0) {
    query[["c[TIME_PERIOD]"]] <- paste(time_filters, collapse = "+")
  }

  # Determine dataflow agency (owner) using dataflows helper
  flows <- get_dataflows_components(
    progress = progress, max_tries = max_tries, cache = cache
  )
  flow_row <- flows[flows$id == dataflow_id, , drop = FALSE]
  if (nrow(flow_row) != 1L) {
    cli::cli_abort("Dataflow not found or not unique: {dataflow_id}.")
  }
  provider_agency <- flow_row$agency[[1]]
  if (is.null(provider_agency) || !nzchar(provider_agency)) {
    provider_agency <- "all"
  }

  # Build path and perform request
  # Build path using SDMX 3.0 dataflow context; layout controlled via query
  data_path <- sprintf(
    "data/%s/%s/%s/+/%s", "dataflow", provider_agency, dataflow_id, key
  )
  message <- perform_request(
    data_path,
    progress = progress,
    max_tries = max_tries,
    cache = cache,
    query_params = query
  )
  # Parse SDMX JSON message into a tidy tibble
  out <- parse_imf_sdmx_json(message)

  # Fallback: Some datasets (e.g., FM annual) ignore c[TIME_PERIOD] but honor
  # startPeriod/endPeriod. If a time window was requested and the result is
  # empty, retry using startPeriod/endPeriod ONLY (no c[TIME_PERIOD]).
  if (length(time_filters) > 0 && nrow(out) == 0) {
    alt_query <- list(
      dimensionAtObservation = "TIME_PERIOD",
      attributes = "dsd",
      measures = "all"
    )
    if (!is.null(start_period)) alt_query[["startPeriod"]] <- start_period
    if (!is.null(end_period)) alt_query[["endPeriod"]] <- end_period

    message2 <- perform_request(
      data_path,
      progress = progress,
      max_tries = max_tries,
      cache = cache,
      query_params = alt_query
    )
    out <- parse_imf_sdmx_json(message2)
  }

  out
}
