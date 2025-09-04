#' Get dataflow definitions for aLL available IMF datasets
#'
#' Retrieves and returns all available dataflow definitions from the SDMX
#' dataflow endpoint.
#'
#' @param progress Logical; whether to show progress.
#' @param max_tries Integer; maximum retry attempts.
#' @return data.frame(
#'   id = character(),           # e.g., "MFS_IR", "SPE", etc.
#'   name = character(),         # English name
#'   description = character(),  # English description
#'   version = character(),      # e.g., "8.0.1"
#'   structure = character(),    # DSD reference
#'   last_updated = character(), # from annotations
#'   stringsAsFactors = FALSE
#' )
#' @examples
#' \dontrun{
#' list_datasets()
#' }
#' @export
imf_get_datasets <- function(progress = FALSE, max_tries = 10L) {
  body <- imf_perform_request(
    resource = "structure/dataflow/IMF.STA/*/+",
    progress = progress,
    max_tries = max_tries
  )

  dataflows <- tryCatch(body[["data"]][["dataflows"]], error = function(e) NULL)

  # Extract core metadata
  datasets <- purrr::map_dfr(dataflows, function(dataflow) {
    # Core required fields
    data.frame(
      id = dataflow$id[[1]],
      name = dataflow$name[[1]],
      description = dataflow$description[[1]],
      version = dataflow$version[[1]],
      structure = dataflow$structure[[1]],
      last_updated = dataflow$annotations[[which(
        vapply(
          dataflow$annotations,
          function(x) "lastUpdatedAt" %in% x$id, logical(1)
        )
      )]]$value[[1]],
      stringsAsFactors = FALSE
    )
  })

  datasets
}
