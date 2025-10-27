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
    id = "DF", agency = "IMF.STA", structure = paste0(
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
    recorded$resource, "^data/dataflow/IMF.STA/DF/\\+/a\\.b1\\+b2\\.\\*$",
    perl = TRUE
  )
  # Plain years are transformed to include -A1 suffix for API compatibility
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2000-A1+le:2002-A1")
  expect_identical(recorded$query$dimensionAtObservation, "TIME_PERIOD")
})

test_that("imf_get warns when provider does not support time filters", {
  # DSD: one non-time dim and TIME_PERIOD present
  components <- list(
    dimensionList = list(
      dimensions = list(list(id = "A", type = "Dimension", position = 1L)),
      timeDimensions = list(list(
        id = "TIME_PERIOD", type = "TimeDimension", position = 2L
      ))
    )
  )
  # Non-STA provider to trigger warning path
  flows <- tibble::tibble(
    id = "DF", agency = "IMF.FAD", structure = paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "DataStructure=IMF:DSD_DF(1.0.0)"
    )
  )

  recorded <- new.env(parent = emptyenv())
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
      recorded$query <- query_params
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  # Expect a warning about ignoring time filters for non-IMF.STA agencies
  expect_warning(
    invisible(imf_get(
      dataflow_id = "DF",
      dimensions = list(A = "x"),
      start_period = "2000",
      end_period = "2001"
    )),
    regexp = "does not support time filters",
    fixed = FALSE
  )

  # Ensure c[TIME_PERIOD] was not included in the query
  expect_false("c[TIME_PERIOD]" %in% names(recorded$query))
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

test_that("imf_get transforms plain year time periods for all frequencies", {
  # Test that plain years are transformed based on frequency
  components <- list(
    dimensionList = list(
      dimensions = list(
        list(id = "COUNTRY", type = "Dimension", position = 0L),
        list(id = "FREQUENCY", type = "Dimension", position = 1L)
      ),
      timeDimensions = list(list(
        id = "TIME_PERIOD", type = "TimeDimension", position = 2L
      ))
    )
  )
  flows <- tibble::tibble(
    id = "DF", agency = "IMF.STA", structure = paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "DataStructure=IMF:DSD_DF(1.0.0)"
    )
  )

  recorded <- new.env(parent = emptyenv())
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
      recorded$query <- query_params
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  # Test annual frequency (A)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "A", COUNTRY = "USA"),
    start_period = "2015",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2015-A1+le:2020-A1")

  # Test quarterly frequency (Q)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "Q", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-Q1+le:2020-Q1")

  # Test monthly frequency (M)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "M", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-01+le:2020-01")

  # Test weekly frequency (W)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "W", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-W01+le:2020-W01")

  # Test semi-annual frequency (S) - should use A1 as fallback
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "S", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-A1+le:2020-A1")

  # Test daily frequency (D) - should use A1 as fallback
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "D", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-A1+le:2020-A1")

  # Test wildcarded frequency (no FREQUENCY specified)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-A1+le:2020-A1")

  # Test multiple frequencies (should use A1 as safe default)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = c("A", "Q"), COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-A1+le:2020-A1")
})

test_that("imf_get preserves already-formatted time periods", {
  # Test that periods with existing suffixes are left unchanged
  components <- list(
    dimensionList = list(
      dimensions = list(
        list(id = "COUNTRY", type = "Dimension", position = 0L),
        list(id = "FREQUENCY", type = "Dimension", position = 1L)
      ),
      timeDimensions = list(list(
        id = "TIME_PERIOD", type = "TimeDimension", position = 2L
      ))
    )
  )
  flows <- tibble::tibble(
    id = "DF", agency = "IMF.STA", structure = paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "DataStructure=IMF:DSD_DF(1.0.0)"
    )
  )

  recorded <- new.env(parent = emptyenv())
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
      recorded$query <- query_params
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  # Monthly format YYYY-MM
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "M", COUNTRY = "USA"),
    start_period = "2019-03",
    end_period = "2019-06"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-03+le:2019-06")

  # Monthly format YYYY-MNN
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "M", COUNTRY = "USA"),
    start_period = "2019-M03",
    end_period = "2019-M06"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-M03+le:2019-M06")

  # Quarterly format YYYY-QN
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "Q", COUNTRY = "USA"),
    start_period = "2019-Q2",
    end_period = "2020-Q1"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-Q2+le:2020-Q1")

  # Weekly format YYYY-WNN
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "W", COUNTRY = "USA"),
    start_period = "2019-W15",
    end_period = "2019-W20"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-W15+le:2019-W20")

  # Annual format YYYY-AN
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "A", COUNTRY = "USA"),
    start_period = "2019-A1",
    end_period = "2020-A1"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-A1+le:2020-A1")
})

test_that("imf_get handles edge cases in time period transformation", {
  components <- list(
    dimensionList = list(
      dimensions = list(
        list(id = "COUNTRY", type = "Dimension", position = 0L),
        list(id = "FREQUENCY", type = "Dimension", position = 1L)
      ),
      timeDimensions = list(list(
        id = "TIME_PERIOD", type = "TimeDimension", position = 2L
      ))
    )
  )
  flows <- tibble::tibble(
    id = "DF", agency = "IMF.STA", structure = paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "DataStructure=IMF:DSD_DF(1.0.0)"
    )
  )

  recorded <- new.env(parent = emptyenv())
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
      recorded$query <- query_params
      list(data = list(
        dataSets = list(list(series = list())), structures = list(list())
      ))
    },
    .package = "imfapi"
  )

  # Test with only start_period (no end_period)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "A", COUNTRY = "USA"),
    start_period = "2015"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2015-A1")

  # Test with only end_period (no start_period)
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "A", COUNTRY = "USA"),
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "le:2020-A1")

  # Test with case insensitive frequency codes
  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "a", COUNTRY = "USA"),
    start_period = "2015",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2015-A1+le:2020-A1")

  invisible(imf_get(
    dataflow_id = "DF",
    dimensions = list(FREQUENCY = "q", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020"
  ))
  expect_identical(recorded$query$`c[TIME_PERIOD]`, "ge:2019-Q1+le:2020-Q1")
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

test_that("imf_get returns annual data with plain year time periods (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()

  # Test the exact scenario from the bug report
  out <- imf_get(
    dataflow_id = "PPI",
    dimensions = list(FREQUENCY = "A", COUNTRY = "USA"),
    start_period = "2015",
    end_period = "2020",
    progress = FALSE,
    max_tries = 3L,
    cache = TRUE
  )

  expect_s3_class(out, "tbl_df")
  expect_gt(nrow(out), 0)
  # Verify all returned periods are within the requested range
  years <- as.integer(out$TIME_PERIOD)
  expect_true(all(years >= 2015 & years <= 2020))
})

test_that("imf_get time filters work for all frequencies (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()

  # Test quarterly data with plain years
  quarterly <- imf_get(
    dataflow_id = "PPI",
    dimensions = list(FREQUENCY = "Q", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020",
    progress = FALSE,
    max_tries = 3L,
    cache = TRUE
  )

  expect_s3_class(quarterly, "tbl_df")
  expect_gt(nrow(quarterly), 0)
  # Verify periods are in the expected format and range
  expect_true(all(grepl("^(2019|2020)-Q[1-4]$", quarterly$TIME_PERIOD)))

  # Test monthly data with plain years
  monthly <- imf_get(
    dataflow_id = "PPI",
    dimensions = list(FREQUENCY = "M", COUNTRY = "USA"),
    start_period = "2019",
    end_period = "2020",
    progress = FALSE,
    max_tries = 3L,
    cache = TRUE
  )

  expect_s3_class(monthly, "tbl_df")
  expect_gt(nrow(monthly), 0)
  # Verify periods are in the expected format
  expect_true(all(grepl("^(2019|2020)-M", monthly$TIME_PERIOD)))

  # Test monthly data with formatted periods (should also work)
  monthly_formatted <- imf_get(
    dataflow_id = "PPI",
    dimensions = list(FREQUENCY = "M", COUNTRY = "USA"),
    start_period = "2019-01",
    end_period = "2019-03",
    progress = FALSE,
    max_tries = 3L,
    cache = TRUE
  )

  expect_s3_class(monthly_formatted, "tbl_df")
  expect_gt(nrow(monthly_formatted), 0)
  # Should return exactly Jan-Mar 2019
  expect_true(
    all(
      monthly_formatted$TIME_PERIOD %in%
        c("2019-01", "2019-02", "2019-03")
    )
  )

  # Test quarterly with formatted periods
  quarterly_formatted <- imf_get(
    dataflow_id = "PPI",
    dimensions = list(FREQUENCY = "Q", COUNTRY = "USA"),
    start_period = "2019-Q2",
    end_period = "2019-Q4",
    progress = FALSE,
    max_tries = 3L,
    cache = TRUE
  )

  expect_s3_class(quarterly_formatted, "tbl_df")
  expect_gt(nrow(quarterly_formatted), 0)
  # Should return Q2-Q4 2019
  expect_true(
    all(
      quarterly_formatted$TIME_PERIOD %in%
        c("2019-Q2", "2019-Q3", "2019-Q4")
    )
  )
})

test_that("Agency time filter support is as expected (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()
  skip("Test of API behavior to be run rarely, to see if API has changed.")

  # Helper: build key from DSD positions
  build_key <- function(dfid, dims = list()) {
    comps <- imfapi:::get_datastructure_components(
      dataflow_id = dfid, progress = FALSE, max_tries = 3L, cache = TRUE
    )
    ds_dims <- comps[["dimensionList"]][["dimensions"]]
    ids <- vapply(ds_dims, function(x) as.character(x$id), character(1))
    pos <- vapply(ds_dims, function(x) as.integer(x$position), integer(1))
    ord <- order(pos)
    ids <- ids[ord]
    segments <- vapply(ids, function(id) {
      v <- dims[[id]]
      if (is.null(v) || length(v) == 0) {
        "*"
      } else {
        paste(as.character(v), collapse = "+")
      }
    }, character(1))
    paste(segments, collapse = ".")
  }

  # Helper: fetch provider agency and path
  build_path <- function(dfid, key) {
    flows <- imfapi:::get_dataflows_components(
      progress = FALSE, max_tries = 3L, cache = TRUE
    )
    row <- flows[flows$id == dfid, , drop = FALSE]
    agency <- row$agency[[1]]
    if (is.null(agency) || !nzchar(agency)) agency <- "all"
    list(
      agency = agency,
      path = sprintf("data/%s/%s/%s/+/%s", "dataflow", agency, dfid, key)
    )
  }

  # Helper: run a c[TIME_PERIOD] query and evaluate results
  run_check <- function(dfid, dims, start_period, end_period) {
    key <- build_key(dfid, dims)
    meta <- build_path(dfid, key)
    query <- list(
      dimensionAtObservation = "TIME_PERIOD",
      attributes = "dsd",
      measures = "all",
      `c[TIME_PERIOD]` = paste0("ge:", start_period, "+le:", end_period)
    )
    message <- tryCatch(
      imfapi:::perform_request(
        meta$path,
        progress = FALSE,
        max_tries = 3L,
        cache = TRUE,
        query_params = query
      ),
      error = function(e) NULL
    )
    if (is.null(message)) {
      return(list(agency = meta$agency, got_rows = FALSE, within = FALSE))
    }
    df <- imfapi:::parse_imf_sdmx_json(message)
    got_rows <- nrow(df) > 0
    # If no rows, or TIME_PERIOD missing, don't attempt to access the column
    if (!got_rows || !("TIME_PERIOD" %in% names(df))) {
      return(list(agency = meta$agency, got_rows = got_rows, within = FALSE))
    }
    # Determine range check
    tp <- as.character(df$TIME_PERIOD)
    if (grepl("-", start_period, fixed = TRUE)) {
      # Monthly: expect all within the same YYYY- prefix (e.g., 2019-)
      yy <- substr(start_period, 1L, 4L)
      within <- all(grepl(paste0("^", yy), tp))
    } else {
      # Annual: expect 4-digit years in inclusive range
      yr <- suppressWarnings(as.integer(substr(tp, 1L, 4L)))
      within <- all(
        !is.na(yr),
        yr >= as.integer(start_period),
        yr <= as.integer(end_period)
      )
    }
    list(agency = meta$agency, got_rows = got_rows, within = within)
  }

  # One dataset per agency where possible; dims chosen to return data
  cases <- list(
    list(
      id = "PPI",
      dims = list(FREQUENCY = "M"),
      start = "2019-01", end = "2019-01"
    ), # IMF.STA
    list(
      id = "HPD",
      dims = list(COUNTRY = "AFG"),
      start = "2015", end = "2020"
    ),    # IMF.FAD
    list(
      id = "FDI",
      dims = list(COUNTRY = "GX1C_AM"),
      start = "2015", end = "2020"
    ),  # IMF.MCM
    list(
      id = "AFRREO",
      dims = list(),
      tart = "2015", end = "2020"
    ),    # IMF.AFR
    list(
      id = "APDREO",
      dims = list(COUNTRY = "GX229"),
      start = "2015",  end = "2020"
    ),    # IMF.APD
    list(
      id = "MCDREO",
      dims = list(COUNTRY = "GX2014"),
      start = "2015", end = "2020"
    ),    # IMF.MCD
    list(
      id = "WHDREO",
      dims = list(),
      start = "2015", end = "2020"
    ),    # IMF.WHD
    list(
      id = "ISORA_LATEST_DATA_PUB",
      dims = list(JURISDICTION = "AFG"),
      start = "2015", end = "2020"
    ) # ISORA
  )

  results <- lapply(cases, function(c) run_check(c$id, c$dims, c$start, c$end))

  # Expectation: IMF.STA should return rows within range; others should not
  for (res in results) {
    if (identical(res$agency, "IMF.STA")) {
      expect_true(
        res$got_rows, info = paste("STA got_rows failed for", res$agency)
      )
      expect_true(
        res$within,  info = paste("STA within-range failed for", res$agency)
      )
    } else {
      expect_false(
        res$got_rows && res$within,
        info = paste("Non-STA unexpectedly within-range:", res$agency)
      )
    }
  }
})
