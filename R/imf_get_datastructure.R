#' Retrieve the datastructure definition for an IMF dataflow.
#'
#' @param dataflow_id The ID of the dataflow to retrieve the datastructure for.
#' @param progress Logical; whether to show progress.
#' @param max_tries Integer; maximum retry attempts.
#' @param cache Logical; whether to cache the request.
#'
#' @return tibble::tibble(
#'   dimension_id = character(),
#'   order = integer(),
#'   concept_id = character(),
#'   concept_name = character(),
#'   role = character(),
#'   codelist_id = character(),
#'   codelist_agency = character(),
#'   representation_type = character(),
#'   stringsAsFactors = FALSE
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
  cache = TRUE
) {
  # DSD resource id is "DSD_" + dataflow_id
  structure_path <- sprintf(
    "structure/datastructure/IMF.STA/DSD_%s/+", dataflow_id
  )

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
      x <- purrr::modify(x, function(v) {
        if (is.list(v)) {
          if (length(v) == 0) list(NULL) else list(v)
        } else {
          v
        }
      })
      tibble::as_tibble(x)
    }
  )

  dimensions
}
