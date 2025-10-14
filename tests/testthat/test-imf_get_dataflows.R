test_that("imf_get_dataflows maps fields and hides structure (mocked)", {
  env <- new.env(parent = emptyenv())
  env$calls <- list()

  mock_body <- list(
    data = list(
      dataflows = list(
        list(
          id = list("MFS_IR"),
          name = list("Monetary and Financial Statistics - Interest Rates"),
          description = list("Interest rates"),
          version = list("8.0.1"),
          agencyID = list("IMF"),
          structure = list(
            paste0(
              "urn:sdmx:org.sdmx.infomodel.datastructure",
              ".DataStructure=IMF:MFS_IR(1.0.0)"
            )
          ),
          annotations = list(
            list(id = list("foo"), value = list("bar")),
            list(
              id = list("lastUpdatedAt"), value = list("2024-01-31T00:00:00Z")
            )
          )
        ),
        list(
          id = list("SPE"),
          name = list("Special Example"),
          description = list("Example dataset"),
          version = list("1.0.0"),
          agencyID = list("IMF"),
          structure = list(
            paste0(
              "urn:sdmx:org.sdmx.infomodel.datastructure",
              ".DataStructure=IMF:SPE(1.0.0)"
            )
          ),
          annotations = list(
            list(
              id = list("lastUpdatedAt"), value = list("2023-02-01T12:34:56Z")
            )
          )
        )
      )
    )
  )

  testthat::local_mocked_bindings(
    perform_request = function(resource, progress, max_tries, cache, ...) {
      env$calls <- append(env$calls, list(list(
        resource = resource,
        progress = progress,
        max_tries = max_tries,
        cache = cache
      )))
      mock_body
    },
    .package = "imfapi"
  )

  out <- imf_get_dataflows(progress = FALSE, max_tries = 3L, cache = TRUE)

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 2L)
  # Structure column is hidden from public API
  expect_false("structure" %in% names(out))
  # Expected columns present
  expect_true(all(
    c("id", "name", "description", "version", "agency", "last_updated")
    %in% names(out)
  ))

  # Spot-check row values mapped correctly
  first <- out[1, ]
  expect_identical(first$id, "MFS_IR")
  expect_match(first$name, "Interest Rates")
  expect_identical(first$version, "8.0.1")
  expect_identical(first$agency, "IMF")
  expect_identical(first$last_updated, "2024-01-31T00:00:00Z")
})

test_that("imf_get_dataflows propagates progress/max_tries/cache", {
  env <- new.env(parent = emptyenv())
  env$last <- NULL

  mock_body <- list(data = list(dataflows = list(
    list(
      id = list("X"), name = list("X"), description = list("X"),
      version = list("1"), agencyID = list("IMF"), structure = list("urn:x"),
      annotations = list(list(
        id = list("lastUpdatedAt"), value = list("2020-01-01")
      ))
    )
  )))

  testthat::local_mocked_bindings(
    perform_request = function(resource, progress, max_tries, cache, ...) {
      env$last <- list(
        resource = resource,
        progress = progress,
        max_tries = max_tries,
        cache = cache
      )
      mock_body
    },
    .package = "imfapi"
  )

  out <- imf_get_dataflows(progress = TRUE, max_tries = 7L, cache = FALSE)
  expect_s3_class(out, "tbl_df")

  expect_identical(env$last$resource, "structure/dataflow/all/*/+")
  expect_identical(env$last$progress, TRUE)
  expect_identical(env$last$max_tries, 7L)
  expect_identical(env$last$cache, FALSE)
})

test_that("imf_get_dataflows errors when no dataflows present (mocked)", {
  testthat::local_mocked_bindings(
    perform_request = function(resource, progress, max_tries, cache, ...) {
      list(data = list(dataflows = NULL))
    },
    .package = "imfapi"
  )

  expect_error(
    imf_get_dataflows(),
    regexp = "No dataflows found in response."
  )
})

test_that("imf_get_dataflows returns tibble with expected columns (live)", {
  skip_on_cran()
  skip_if_offline()
  out <- imf_get_dataflows(progress = FALSE, max_tries = 3L, cache = TRUE)
  expect_s3_class(out, "tbl_df")
  expect_true(nrow(out) > 0)
  expect_true(all(
    c("id", "name", "description", "version", "agency", "last_updated")
    %in% names(out)
  ))
  expect_false("structure" %in% names(out))
})
