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
#' \dontrun{
#' imf_get_datastructure("GFS")
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
  # DSD resource id is "DSD_" + dataflow_id
  structure_path <- sprintf(
    "structure/datastructure/IMF.STA/DSD_%s/+", dataflow_id
  )

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

  # Request the datastructure and get the components
  body <- imf_perform_request(
    structure_path,
    progress = progress,
    max_tries = max_tries,
    cache = cache
  )
  components <- tryCatch(
    body[["data"]][["dataStructures"]][[1]][["dataStructureComponents"]],
    error = function(e) NULL
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
