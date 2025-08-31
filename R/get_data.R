#' Retrieve data from an IMF dataset.
#'
#' @examples
#' \dontrun{
#' get_data("GFS", )
#' }
#' @noRd
get_data <- function(resource_id, key, context = "TIME_SERIES") {
  # {base_url}/data/{context}/IMF.STA/{resourceID}/+/{key}?dimensionsAtObservation={dimensions_at_observation}&attributes={attributes}&measures={measures}
  data_url <- sprintf("data/%s/IMF.STA/%s/+/%s", context, resource_id, key)
  body <- perform_request(data_url)
  body
}