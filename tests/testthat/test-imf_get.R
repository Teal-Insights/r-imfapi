test_that("imf_get validates inputs", {
  expect_error(
    imf_get(dataflow_id = NA_character_), regexp = "non-empty character scalar"
  )
  expect_error(
    imf_get(dataflow_id = "X", dimensions = 1), regexp = "named list"
  )
  dims <- list(a = NULL)
  dims[[""]] <- 1
  expect_error(
    imf_get(dataflow_id = "X", dimensions = dims),
    regexp = "named list with non-empty names"
  )
})

test_that("imf_get builds key from DSD positions and applies time filters", {
  # Mock DSD with three non-time dims in order and TIME_PERIOD as time dim
  components <- list(
    dimensionList = list(
      dimensions = list(
        list(id = "A", type = "Dimension", position = 1L),
        list(id = "B", type = "Dimension", position = 2L),
        list(id = "C", type = "Dimension", position = 3L)
      ),
      timeDimensions = list(list(
        id = "TIME_PERIOD", type = "TimeDimension", position = 4L
      ))
    )
  )
  flows <- tibble::tibble(
    id = "DF", agency = "IMF", structure = paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "DataStructure=IMF:DSD_DF(1.0.0)"
    )
  )

  recorded <- new.env(parent = emptyenv())
  recorded$resource <- NULL
  recorded$query <- NULL

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      components
    },
    get_dataflows_components = function(progress, max_tries, cache) {
      flows
    },
    perform_request = function(
      resource, progress, max_tries, cache, query_params
    ) {
      recorded$resource <- resource
      recorded$query <- query_params
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(B = c("b1", "b2"), A = c("a")),
    start_period = "2000",
    end_period = "2002"
  ))

  expect_match(
    recorded$resource, "^data/dataflow/IMF/DF/\\+/a\\.b1\\+b2\\.\\*$",
    perl = TRUE
  )
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2000+le:2002")
  expect_identical(recorded$query$dimensionAtObservation, "TIME_PERIOD")
})

test_that("imf_get resolves provider and falls back to 'all'", {
  components <- list(
    dimensionList = list(
      dimensions = list(list(id = "A", type = "Dimension", position = 1L)),
      timeDimensions = list()
    )
  )
  flows <- tibble::tibble(
    id = c("DF1", "DF2"),
    agency = c("IMF.STA", ""),
    structure = c(
      paste0(
        "urn:sdmx:org.sdmx.infomodel.datastructure.",
        "DataStructure=IMF:DSD_DF1(1.0.0)"
      ),
      paste0(
        "urn:sdmx:org.sdmx.infomodel.datastructure.",
        "DataStructure=IMF:DSD_DF2(1.0.0)"
      )
    )
  )
  seen <- list()
  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      components
    },
    get_dataflows_components = function(progress, max_tries, cache) {
      flows
    },
    perform_request = function(
      resource, progress, max_tries, cache, query_params
    ) {
      seen <<- append(seen, list(list(resource = resource)))
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  invisible(imf_get("DF1"))
  invisible(imf_get("DF2"))

  expect_true(any(grepl(
    "^data/dataflow/IMF.STA/DF1/\\+/", sapply(seen, `[[`, "resource")
  )))
  expect_true(any(grepl(
    "^data/dataflow/all/DF2/\\+/", sapply(seen, `[[`, "resource")
  )))
})

test_that("imf_get normalizes dimensions and errors on unknown names", {
  components <- list(
    dimensionList = list(
      dimensions = list(list(id = "A", position = 1L, type = "Dimension")),
      timeDimensions = list()
    )
  )
  flows <- tibble::tibble(
    id = "DF", agency = "IMF", structure = paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "DataStructure=IMF:DSD_DF(1.0.0)"
    )
  )
  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      components
    },
    get_dataflows_components = function(progress, max_tries, cache) {
      flows
    },
    perform_request = function(
      resource, progress, max_tries, cache, query_params
    ) {
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  # normalization: trim/unique/character casting
  invisible(imf_get("DF", dimensions = list(A = c(" x ", "x"))))

  # unknown dimension name should abort
  expect_error(
    imf_get("DF", dimensions = list(UNKNOWN = "x")),
    regexp = "Unknown dimension"
  )
})

test_that("imf_get errors when dataflow not found or not unique", {
  components <- list(
    dimensionList = list(
      dimensions = list(list(id = "A", type = "Dimension", position = 1L)),
      timeDimensions = list()
    )
  )
  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      components
    },
    get_dataflows_components = function(progress, max_tries, cache) {
      tibble::tibble(
        id = c("X", "X"), agency = c("A", "B"), structure = c("urn:x", "urn:y")
      )
    },
    .package = "imfapi"
  )
  expect_error(imf_get("X"), regexp = "Dataflow not found or not unique")
})

test_that("imf_get treats NULL dimension value as wildcard", {
  # Mock DSD with three non-time dims in order and TIME_PERIOD as time dim
  components <- list(
    dimensionList = list(
      dimensions = list(
        list(id = "A", type = "Dimension", position = 1L),
        list(id = "B", type = "Dimension", position = 2L),
        list(id = "C", type = "Dimension", position = 3L)
      ),
      timeDimensions = list(list(
        id = "TIME_PERIOD", type = "TimeDimension", position = 4L
      ))
    )
  )
  flows <- tibble::tibble(
    id = "DF", agency = "IMF", structure = paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "DataStructure=IMF:DSD_DF(1.0.0)"
    )
  )

  recorded <- new.env(parent = emptyenv())
  recorded$resource <- NULL

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      components
    },
    get_dataflows_components = function(progress, max_tries, cache) {
      flows
    },
    perform_request = function(
      resource, progress, max_tries, cache, query_params
    ) {
      recorded$resource <- resource
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  # A = NULL should be normalized to wildcard "*" in the first segment
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(A = NULL, B = c("b1"))
  ))

  expect_match(
    recorded$resource, "^data/dataflow/IMF/DF/\\+/\\*\\.b1\\.\\*$",
    perl = TRUE
  )
})

test_that("imf_get returns data within requested time window (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()

  # Request a very narrow monthly slice to keep payload small
  out <- imf_get(
    dataflow_id = "MFS_IR",
    dimensions = list(FREQUENCY = "M"),
    start_period = "2019-01",
    end_period = "2019-01",
    progress = FALSE,
    max_tries = 3L,
    cache = TRUE
  )

  expect_s3_class(out, "tbl_df")
  expect_true(all(out$TIME_PERIOD == "2019-M01"))
})
