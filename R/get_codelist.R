#' Retrieve the list of codes for a dimension of an IMF dataset.
#'
#' @noRd

get_codelist <- function(resource_id) {
  codelist_url <- sprintf("structure/codelist/IMF.STA/%s/+", resource_id)
  body <- perform_request(codelist_url)
  body
}