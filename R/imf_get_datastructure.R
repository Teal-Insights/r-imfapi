#' Retrieve the datastructure definition for an IMF dataflow.
#'
#' @param dataflow_id The ID of the dataflow to retrieve the datastructure for.
#' @param progress Logical; whether to show progress.
#' @param max_tries Integer; maximum retry attempts.
#' @param cache Logical; whether to cache the request.
#' @param include_time Logical; whether to include time dimensions.
#' @param include_measures Logical; whether to include measure dimensions.
#'
#' @return tibble::tibble(
#'   dimension_id = character(),
#'   type = character(),
#'   position = integer()
#' )
#'
#' @examples
#' \donttest{
#' if (curl::has_internet()) {
#'   imf_get_datastructure("PSBS")
#' }
#' }
#' @export
imf_get_datastructure <- function(
  dataflow_id,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE,
  include_time = FALSE,
  include_measures = FALSE
) {
  # Argument validation
  if (
    !is.logical(include_time) || length(include_time) != 1L ||
      is.na(include_time)
  ) {
    cli::cli_abort("{.arg include_time} must be a single non-missing logical.")
  }
  if (
    !is.logical(include_measures) || length(include_measures) != 1L ||
      is.na(include_measures)
  ) {
    cli::cli_abort(
      "{.arg include_measures} must be a single non-missing logical."
    )
  }

  components <- get_datastructure_components(
    dataflow_id = dataflow_id,
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )

  # This is necessary because tibble drops rows with zero-length lists
  dimensions <- purrr::map_dfr(
    components[["dimensionList"]][["dimensions"]], function(x) {
      tibble::tibble(
        dimension_id = x$id,
        type = x$type,
        position = x$position
      )
    }
  )
  if (isTRUE(include_time)) {
    dimensions <- dplyr::bind_rows(dimensions, purrr::map_dfr(
      components[["dimensionList"]][["timeDimensions"]], function(x) {
        tibble::tibble(
          dimension_id = x$id,
          type = x$type,
          position = x$position
        )
      }
    ))
  }
  if (isTRUE(include_measures)) {
    dimensions <- dplyr::bind_rows(dimensions, purrr::map_dfr(
      components[["measureList"]][["measures"]], function(x) {
        tibble::tibble(
          dimension_id = x$id,
          type = "Measure",
          position = x$position
        )
      }
    ))
  }

  dimensions
}

#' Retrieve raw datastructure components for a dataflow (internal)
#'
#' @keywords internal
#' @noRd
get_datastructure_components <- function(
  dataflow_id,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE
) {
  if (
    !is.character(dataflow_id) || length(dataflow_id) != 1L ||
      is.na(dataflow_id) || !nzchar(trimws(dataflow_id))
  ) {
    cli::cli_abort("{.arg dataflow_id} must be a non-empty character scalar.")
  }

  # Resolve DSD from dataflow structure URN using internal dataflows helper
  flows <- get_dataflows_components(
    progress = progress, max_tries = max_tries, cache = cache
  )
  flow_row <- flows[flows$id == dataflow_id, , drop = FALSE]
  if (nrow(flow_row) != 1L) {
    cli::cli_abort("Dataflow not found or not unique: {dataflow_id}.")
  }
  dsd_ref <- parse_datastructure_urn(flow_row$structure[[1]])
  if (
    is.na(dsd_ref$agency) || !nzchar(dsd_ref$agency) ||
      is.na(dsd_ref$id) || !nzchar(dsd_ref$id)
  ) {
    cli::cli_abort("Invalid structure URN for dataflow {dataflow_id}.")
  }
  dsd_body <- perform_request(
    sprintf("structure/datastructure/%s/%s/+", dsd_ref$agency, dsd_ref$id),
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )

  dsds <- dsd_body[["data"]][["dataStructures"]]
  if (is.null(dsds) || length(dsds) < 1) {
    cli::cli_abort("No dataStructures found in DSD response for {dataflow_id}.")
  }
  components <- dsds[[1]][["dataStructureComponents"]]
  if (is.null(components)) {
    cli::cli_abort(
      "No dataStructureComponents found in DSD for {dataflow_id}."
    )
  }

  components
}
