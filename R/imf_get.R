#' Retrieve data from an IMF dataset.
#'
#' @examples
#' \dontrun{
#' imf_get("GFS", )
#' }
#' @noRd
imf_get <- function(resource_id, key, context = "TIME_SERIES") {
  # {base_url}/data/{context}/IMF.STA/{resourceID}/+/{key}?dimensionsAtObservation={dimensions_at_observation}&attributes={attributes}&measures={measures}
  data_url <- sprintf("data/%s/all/%s/+/%s", context, resource_id, key)
  body <- perform_request(data_url)
  body

  # In the JSON response, `data.datastructure` is an array of objects and **each** object contains a `dataStructureComponents` field which contains a `dimensionsList` object. 

  # `dimensionList` has 2 main entries.

  # 1. `dimensions` which is a list of **dimensions**.
  # 2. `timedimensions` which is a list of **time dimensions**.
}