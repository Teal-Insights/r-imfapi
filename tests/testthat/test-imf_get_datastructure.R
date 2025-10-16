test_that("imf_get_datastructure maps dimensions/time/measures correctly", {
  components <- list(
    dimensionList = list(
      dimensions = list(
        list(id = "GEO", type = "Dimension", position = 1L),
        list(id = "FREQUENCY", type = "Dimension", position = 2L)
      ),
      timeDimensions = list(
        list(id = "TIME_PERIOD", type = "TimeDimension", position = 3L)
      )
    ),
    measureList = list(
      measures = list(
        list(id = "OBS_VALUE", position = 4L)
      )
    )
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      components
    },
    .package = "imfapi"
  )

  # Only core dimensions
  dims_only <- imf_get_datastructure(
    dataflow_id = "X", include_time = FALSE, include_measures = FALSE
  )
  expect_s3_class(dims_only, "tbl_df")
  expect_equal(nrow(dims_only), 2L)
  expect_true(all(dims_only$dimension_id %in% c("GEO", "FREQUENCY")))
  expect_true(all(dims_only$type == "Dimension"))

  # Include time
  with_time <- imf_get_datastructure(
    dataflow_id = "X", include_time = TRUE, include_measures = FALSE
  )
  expect_equal(nrow(with_time), 3L)
  expect_true("TIME_PERIOD" %in% with_time$dimension_id)

  # Include measures
  with_all <- imf_get_datastructure(
    dataflow_id = "X", include_time = TRUE, include_measures = TRUE
  )
  expect_equal(nrow(with_all), 4L)
  expect_true(any(
    with_all$dimension_id == "OBS_VALUE" & with_all$type == "Measure"
  ))
})

test_that("imf_get_datastructure propagates progress/max_tries/cache", {
  recorded <- NULL
  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      recorded <<- list(
        dataflow_id = dataflow_id,
        progress = progress,
        max_tries = max_tries,
        cache = cache
      )
      list(
        dimensionList = list(dimensions = list(), timeDimensions = list()),
        measureList = list(measures = list())
      )
    },
    .package = "imfapi"
  )

  out <- imf_get_datastructure(
    dataflow_id = "DFX", progress = TRUE, max_tries = 7L, cache = FALSE,
    include_time = TRUE, include_measures = TRUE
  )
  expect_s3_class(out, "tbl_df")
  expect_identical(recorded$dataflow_id, "DFX")
  expect_identical(recorded$progress, TRUE)
  expect_identical(recorded$max_tries, 7L)
  expect_identical(recorded$cache, FALSE)
})

test_that("get_datastructure_components makes calls and returns components", {
  df_calls <- list()
  pr_calls <- list()
  components <- list(
    dimensionList = list(dimensions = list(), timeDimensions = list()),
    measureList = list(measures = list())
  )
  flows <- tibble::tibble(
    id = c("ABC"),
    structure = c(
      paste0(
        "urn:sdmx:org.sdmx.infomodel.datastructure.",
        "DataStructure=IMF:DSD_ABC(1.0.0)"
      )
    )
  )

  testthat::local_mocked_bindings(
    get_dataflows_components = function(progress, max_tries, cache) {
      df_calls <<- append(
        df_calls,
        list(list(progress = progress, max_tries = max_tries, cache = cache))
      )
      flows
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      pr_calls <<- append(
        pr_calls,
        list(list(
          resource = resource,
          progress = progress,
          max_tries = max_tries,
          cache = cache
        ))
      )
      list(data = list(
        dataStructures = list(list(dataStructureComponents = components))
      ))
    },
    .package = "imfapi"
  )

  out <- get_datastructure_components(
    dataflow_id = "ABC", progress = TRUE, max_tries = 9L, cache = FALSE
  )
  expect_identical(out, components)
  # Helper should have propagated args to both calls
  expect_identical(df_calls[[1]]$progress, TRUE)
  expect_identical(df_calls[[1]]$max_tries, 9L)
  expect_identical(df_calls[[1]]$cache, FALSE)
  expect_identical(pr_calls[[1]]$progress, TRUE)
  expect_identical(pr_calls[[1]]$max_tries, 9L)
  expect_identical(pr_calls[[1]]$cache, FALSE)
  expect_identical(
    pr_calls[[1]]$resource, "structure/datastructure/IMF/DSD_ABC/+"
  )
})

test_that("get_datastructure_components validates dataflow_id presence", {
  # Invalid dataflow_id
  expect_error(
    get_datastructure_components(NA_character_),
    regexp = "dataflow_id.*non-empty character scalar"
  )

  # Dataflow not found
  testthat::local_mocked_bindings(
    get_dataflows_components = function(
      progress, max_tries, cache
    ) {
      tibble::tibble(
        id = c("XYZ"), structure = c(NA_character_)
      )
    },
    .package = "imfapi"
  )
  expect_error(
    get_datastructure_components("NOPE"),
    regexp = "Dataflow not found or not unique"
  )
})

test_that("get_datastructure_components errors on invalid DSD URN", {
  testthat::local_mocked_bindings(
    get_dataflows_components = function(progress, max_tries, cache) {
      tibble::tibble(id = "ABC", structure = "not-a-urn")
    },
    .package = "imfapi"
  )
  expect_error(
    get_datastructure_components("ABC"),
    regexp = "Invalid structure URN"
  )
})

test_that("get_datastructure_components errors when dataStructures missing", {
  mock_gdc <- function(progress, max_tries, cache) {
    tibble::tibble(
      id = "ABC",
      structure = paste0(
        "urn:sdmx:org.sdmx.infomodel.datastructure.",
        "DataStructure=IMF:DSD_ABC(1.0.0)"
      )
    )
  }
  mock_pr <- function(resource, progress, max_tries, cache, ...) {
    list(data = list(dataStructures = list()))
  }
  testthat::local_mocked_bindings(
    get_dataflows_components = mock_gdc,
    perform_request = mock_pr,
    .package = "imfapi"
  )
  # Verify mocks are active in the package namespace
  expect_identical(
    getFromNamespace("get_dataflows_components", "imfapi"),
    mock_gdc
  )
  expect_identical(
    getFromNamespace("perform_request", "imfapi"),
    mock_pr
  )
  expect_error(
    get_datastructure_components("ABC"),
    regexp = "No dataStructures found"
  )
})

test_that("get_datastructure_components errors when components missing", {
  mock_gdc <- function(progress, max_tries, cache) {
    tibble::tibble(
      id = "ABC",
      structure = paste0(
        "urn:sdmx:org.sdmx.infomodel.datastructure.",
        "DataStructure=IMF:DSD_ABC(1.0.0)"
      )
    )
  }
  mock_pr <- function(resource, progress, max_tries, cache, ...) {
    list(
      data = list(
        dataStructures = list(
          list(
            dataStructureComponents = NULL
          )
        )
      )
    )
  }
  testthat::local_mocked_bindings(
    get_dataflows_components = mock_gdc,
    perform_request = mock_pr,
    .package = "imfapi"
  )
  expect_identical(
    getFromNamespace("get_dataflows_components", "imfapi"),
    mock_gdc
  )
  expect_identical(
    getFromNamespace("perform_request", "imfapi"),
    mock_pr
  )
  expect_error(
    get_datastructure_components("ABC"),
    regexp = "No dataStructureComponents found"
  )
})

test_that("imf_get_datastructure validates include flags", {
  expect_error(
    imf_get_datastructure("X", include_time = c(TRUE, FALSE)),
    regexp = "include_time.*single non-missing logical"
  )
  expect_error(
    imf_get_datastructure("X", include_measures = NA),
    regexp = "include_measures.*single non-missing logical"
  )
})

test_that("get_datastructure_components errors on non-unique dataflow rows", {
  mock_gdc <- function(progress, max_tries, cache) {
    tibble::tibble(
      id = c("D1", "D1"),
      structure = c(
        paste0(
          "urn:sdmx:org.sdmx.infomodel.datastructure.",
          "DataStructure=IMF:DSD_D1(1.0.0)"
        ),
        paste0(
          "urn:sdmx:org.sdmx.infomodel.datastructure.",
          "DataStructure=IMF:DSD_D1(2.0.0)"
        )
      )
    )
  }
  testthat::local_mocked_bindings(
    get_dataflows_components = mock_gdc,
    .package = "imfapi"
  )
  expect_identical(
    getFromNamespace("get_dataflows_components", "imfapi"),
    mock_gdc
  )
  expect_error(
    get_datastructure_components("D1"),
    regexp = "Dataflow not found or not unique"
  )
})

test_that("imf_get_datastructure returns data (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()
  out <- imf_get_datastructure("MFS_IR", include_time = TRUE)
  expect_s3_class(out, "tbl_df")
  expect_true(all(c("dimension_id", "type", "position") %in% names(out)))
  expect_true(nrow(out) >= 1)
})
