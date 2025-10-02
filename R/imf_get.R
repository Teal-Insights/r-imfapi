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
#' @param resource_id Character scalar. The dataset/resource within the
#'   dataflow (e.g., a table or domain identifier).
#' @param dimensions Named list mapping dimension IDs to character vectors of
#'   codes to include. Omitted dimensions are wildcarded in the key. Each
#'   dimension position in the DSD corresponds to one dot-separated slot in the
#'   key; multiple codes per slot are joined by '+'.
#' @param start_period Optional character. Lower bound for time filtering
#'   (e.g., "2000", "2000-Q1", "2000-01").
#' @param end_period Optional character. Upper bound for time filtering, same
#'   format as `start_period`.
#' @param context Character scalar. SDMX data context path segment.
#'   Common values include "TIME_SERIES", "CROSS_SECTIONAL", and "FLAT".
#'   Defaults to "TIME_SERIES".
#' @param attributes Character scalar. Which attribute metadata to include.
#'   One of "All", "Dataset", "Series", "Observation", or "None".
#'   Defaults to "None" in practice; exposed here for experimentation.
#' @param measures Character scalar. Which measures to include when a dataset
#'   defines multiple measures. Typically "All"; specific measure IDs may be
#'   supported for some datasets.
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
#' \dontrun{
#' # Minimal time-series retrieval with COUNTRY filtered
#' imf_get(
#'   dataflow_id = "GFS",
#'   resource_id = "GFS",
#'   dimensions = list(COUNTRY = c("USA", "CAN")),
#'   start_period = "2015",
#'   end_period = "2020"
#' )
#'
#' # Cross-sectional or flat contexts can be explored if needed
#' imf_get(
#'   dataflow_id = "GFS",
#'   resource_id = "GFS",
#'   context = "CROSS_SECTIONAL",
#'   attributes = "Series"
#' )
#' }
#' @export
imf_get <- function(
  dataflow_id,
  resource_id,
  dimensions = list(),
  start_period = NULL,
  end_period = NULL,
  context = "TIME_SERIES",
  attributes = c("All", "Dataset", "Series", "Observation", "None"),
  measures = c("All", "None"),
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
  if (
    !is.character(resource_id) || length(resource_id) != 1L ||
      is.na(resource_id) || !nzchar(trimws(resource_id))
  ) {
    cli::cli_abort("{.arg resource_id} must be a non-empty character scalar.")
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
  # Determine provider agency from DSD (fallback to "all")
  dsd_meta <- perform_request(
    sprintf("structure/datastructure/all/DSD_%s/+", dataflow_id),
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )
  provider_agency <- tryCatch(
    as.character(dsd_meta[["data"]][["dataStructures"]][[1]][["agencyID"]]),
    error = function(e) NULL
  )
  if (is.null(provider_agency) || !nzchar(provider_agency)) {
    provider_agency <- "all"
  }
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
    attributes = tolower(match.arg(attributes)),
    measures = tolower(match.arg(measures))
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

  # Determine dataflow agency (owner) for the route
  df_meta <- perform_request(
    sprintf("structure/dataflow/all/%s/+", dataflow_id),
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )
  provider_agency <- tryCatch(
    as.character(df_meta[["data"]][["dataflows"]][[1]][["agencyID"]]),
    error = function(e) NULL
  )
  if (is.null(provider_agency) || !nzchar(provider_agency)) {
    provider_agency <- "all"
  }

  # Build path and perform request
  data_path <- sprintf(
    "data/%s/%s/%s/+/%s", context, provider_agency, resource_id, key
  )
  body <- perform_request(
    data_path,
    progress = progress,
    max_tries = max_tries,
    cache = cache,
    query_params = query
  )
  body
}