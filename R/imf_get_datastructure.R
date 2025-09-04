#' Retrieve the datastructure for an IMF dataset.
#'
#' @examples
#' \dontrun{
#' get_datastructure("DSD_GFS")
#' }
#' @noRd
get_datastructure <- function(resource_id) {
  # TODO: query by dataset ID: resource ID == DSD_ + dataset ID (I think)
  structure_url <- sprintf("structure/datastructure/IMF.STA/%s/+", resource_id)
  body <- imf_perform_request(structure_url)
  # TODO: extract and return a usable dataframe with dimensions
  body
}
