#' Safely extract the first scalar from a list
#'
#' @param x The list to extract from.
#' @return The first scalar.
#' @keywords internal
#' @noRd
first_scalar <- function(x) {
  if (is.null(x)) return(NA_character_)
  if (is.list(x)) x <- unlist(x, use.names = FALSE, recursive = TRUE)
  if (length(x) == 0) return(NA_character_)
  as.character(x[[1]])
}

#' Parse a concept URN into a list of components
#'
#' @param urn The URN to parse.
#' @return A list of components.
#' @keywords internal
#' @noRd
parse_concept_urn <- function(urn) {
  m <- regexec(
    paste0(
      "^urn:sdmx:org\\.sdmx\\.infomodel\\.conceptscheme\\.Concept=",
      "([^:]+):([^\\(]+)\\(([^\\)]+)\\)\\.(.+)$"
    ),
    first_scalar(urn)
  )
  p <- regmatches(first_scalar(urn), m)[[1]]
  if (length(p) == 5) {
    list(
      agency = p[2],
      scheme = p[3],
      version = p[4],
      concept = p[5]
    )
  } else {
    list(
      agency = NA_character_,
      scheme = NA_character_,
      version = NA_character_,
      concept = NA_character_
    )
  }
}

#' Parse a codelist URN into a list of components
#'
#' @param urn The URN to parse.
#' @return A list of components.
#' @keywords internal
#' @noRd
parse_codelist_urn <- function(urn) {
  m <- regexec(
    paste0(
      "^urn:sdmx:org\\.sdmx\\.infomodel\\.codelist\\.(?:CodeList|Codelist)=",
      "([^:]+):([^\\(]+)\\(([^\\)]+)\\)$"
    ),
    first_scalar(urn)
  )
  p <- regmatches(first_scalar(urn), m)[[1]]
  if (length(p) == 4) {
    list(agency = p[2], id = p[3], version = p[4])
  } else {
    list(agency = NA_character_, id = NA_character_, version = NA_character_)
  }
}

#' Parse a datastructure (DSD) URN into a list of components
#'
#' @param urn The URN to parse.
#' @return A list with agency, id, version (NA_character_ on failure).
#' @keywords internal
#' @noRd
parse_datastructure_urn <- function(urn) {
  m <- regexec(
    paste0(
      "^urn:sdmx:org\\.sdmx\\.infomodel\\.datastructure\\.DataStructure=",
      "([^:]+):([^\\(]+)\\(([^\\)]+)\\)$"
    ),
    first_scalar(urn)
  )
  p <- regmatches(first_scalar(urn), m)[[1]]
  if (length(p) == 4) {
    list(agency = p[2], id = p[3], version = p[4])
  } else {
    list(agency = NA_character_, id = NA_character_, version = NA_character_)
  }
}
