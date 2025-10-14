test_that("returns empty tibble for NULL or missing data", {
  expect_s3_class(parse_imf_sdmx_json(NULL), "tbl_df")
  expect_identical(nrow(parse_imf_sdmx_json(NULL)), 0L)

  expect_identical(
    nrow(parse_imf_sdmx_json(list(meta = list()))), 0L
  )
})

test_that("returns empty tibble when dataSets/structures missing or empty", {
  msg1 <- list(data = list(dataSets = NULL, structures = list(list())))
  expect_identical(nrow(parse_imf_sdmx_json(msg1)), 0L)

  msg2 <- list(data = list(dataSets = list(), structures = list(list())))
  expect_identical(nrow(parse_imf_sdmx_json(msg2)), 0L)

  msg3 <- list(data = list(dataSets = list(list()), structures = NULL))
  expect_identical(nrow(parse_imf_sdmx_json(msg3)), 0L)
})

test_that("returns empty tibble when series missing or observations empty", {
  # structures minimally present
  st <- list(dimensions = list(series = list(), observation = list()))
  msg <- list(data = list(dataSets = list(list(series = NULL)), structures = list(st)))
  expect_identical(nrow(parse_imf_sdmx_json(msg)), 0L)

  # series present but no observations -> rows list stays empty
  st <- list(
    dimensions = list(
      series = list(list(id = "D1", values = list(list(id = "X")))),
      observation = list(list(id = "TIME_PERIOD", values = list(list(value = "T1"))))
    )
  )
  ds <- list(series = list(`0` = list(observations = list())))
  msg2 <- list(data = list(dataSets = list(ds), structures = list(st)))
  expect_identical(nrow(parse_imf_sdmx_json(msg2)), 0L)
})

test_that("parses real PPI fixture to non-empty tibble", {
  fp <- testthat::test_path("fixtures", "ppi_message.json")
  testthat::skip_if_not(file.exists(fp), "fixture missing")
  msg <- jsonlite::fromJSON(fp, simplifyVector = FALSE)
  out <- parse_imf_sdmx_json(msg)
  expect_s3_class(out, "tbl_df")
  expect_gt(nrow(out), 0L)
  expect_true(all(c("TIME_PERIOD", "OBS_VALUE") %in% names(out)))
  # spot check a known row shape
  expect_true(all(c("COUNTRY", "FREQUENCY") %in% names(out)))
})

test_that("maps series indices to codes with id/value fallback and padding", {
  # Build a small synthetic message
  st <- list(
    dimensions = list(
      series = list(
        list(id = "D1", values = list(list(id = "A"))),
        list(id = "D2", values = list(list(value = "VAL_ONLY"))) # no id
      ),
      observation = list(list(
        id = "TIME_PERIOD",
        values = list(list(value = "P1"), list(id = "P2")) # value then id
      ))
    )
  )
  # Two series keys: one with only first index (padding triggers), one with both
  ds <- list(series = list(
    `0` = list(
      observations = list(
        `0` = list("1.23"),   # numeric string
        `1` = list("NP")       # non-numeric flag
      )
    ),
    `0:0` = list(
      observations = list(
        `0` = list("2.5")
      )
    )
  ))
  msg <- list(data = list(dataSets = list(ds), structures = list(st)))
  out <- parse_imf_sdmx_json(msg)

  # Expect three observations parsed
  expect_equal(nrow(out), 3L)
  expect_true(all(c("D1", "D2", "TIME_PERIOD", "OBS_VALUE") %in% names(out)))

  # First two rows come from key `0` with D1 mapped by id and D2 padded to NA
  expect_identical(out$D1[[1]], "A")
  expect_true(is.na(out$D2[[1]]))
  # TIME_PERIOD maps value then id fallback
  expect_identical(out$TIME_PERIOD[[1]], "P1")
  expect_identical(out$TIME_PERIOD[[2]], "P2")
  # OBS_VALUE coercion: numeric string -> numeric; flag -> NA
  expect_equal(out$OBS_VALUE[[1]], 1.23, tolerance = 1e-8)
  expect_true(is.na(out$OBS_VALUE[[2]]))

  # Third row from key `0:0` should have D2 from value-only entry
  third <- out[3, ]
  expect_identical(third$D2[[1]], "VAL_ONLY")
})

test_that("handles out-of-range and non-integer series indices gracefully", {
  st <- list(
    dimensions = list(
      series = list(list(id = "D1", values = list(list(id = "X")))),
      observation = list(list(id = "TIME_PERIOD", values = list(list(value = "T"))))
    )
  )
  # key uses non-integer index 'abc' -> NA code
  ds <- list(series = list(
    `abc` = list(observations = list(`0` = list("3.14"))),
    # out-of-range index '9' for a single value list -> NA code
    `9` = list(observations = list(`0` = list("4.2")))
  ))
  msg <- list(data = list(dataSets = list(ds), structures = list(st)))
  out <- parse_imf_sdmx_json(msg)
  expect_equal(nrow(out), 2L)
  expect_true(all(is.na(out$D1)))
  expect_true(all(out$OBS_VALUE > 0))
})

test_that("missing observation dimension yields NA TIME_PERIOD", {
  st <- list(dimensions = list(series = list(list(id = "D1", values = list(list(id = "X")))), observation = list()))
  ds <- list(series = list(`0` = list(observations = list(`0` = list("1.0")))))
  msg <- list(data = list(dataSets = list(ds), structures = list(st)))
  out <- parse_imf_sdmx_json(msg)
  expect_identical(out$TIME_PERIOD[[1]], NA_character_)
  expect_identical(out$D1[[1]], "X")
  expect_equal(out$OBS_VALUE[[1]], 1.0, tolerance = 1e-8)
})

test_that("index_to_code returns NA when dimension values are missing/empty", {
  st <- list(
    dimensions = list(
      series = list(
        list(id = "D1", values = NULL),                     # triggers length check -> NA
        list(id = "D2", values = list(list(id = "X")))     # normal mapping
      ),
      observation = list(list(id = "TIME_PERIOD", values = list(list(value = "T1"))))
    )
  )
  ds <- list(series = list(
    `0:0` = list(observations = list(`0` = list("1")))
  ))
  msg <- list(data = list(dataSets = list(ds), structures = list(st)))
  out <- parse_imf_sdmx_json(msg)
  expect_equal(nrow(out), 1L)
  expect_true(is.na(out$D1[[1]]))
  expect_identical(out$D2[[1]], "X")
})

test_that("parses rows when no series dimensions metadata is present", {
  st <- list(
    dimensions = list(
      series = list(),                                        # no series dims -> character(0) path
      observation = list(list(id = "TIME_PERIOD", values = list(list(value = "T1"), list(value = "T2"))))
    )
  )
  ds <- list(series = list(
    `0` = list(observations = list(`0` = list("1.0"), `1` = list("2.0")))
  ))
  msg <- list(data = list(dataSets = list(ds), structures = list(st)))
  out <- parse_imf_sdmx_json(msg)
  expect_equal(nrow(out), 2L)
  expect_true(all(c("TIME_PERIOD", "OBS_VALUE") %in% names(out)))
  # No series columns should be present
  expect_equal(setdiff(names(out), c("TIME_PERIOD", "OBS_VALUE")), character(0))
})

test_that("non-integer and out-of-range observation indices yield NA TIME_PERIOD", {
  st <- list(
    dimensions = list(
      series = list(list(id = "D1", values = list(list(id = "A")))),
      observation = list(list(id = "TIME_PERIOD", values = list(list(value = "ONLY_ONE"))))
    )
  )
  ds <- list(series = list(
    `0` = list(observations = list(
      foo = list("3.0"),   # non-integer -> is.na(i) branch
      `9` = list("4.0")    # out-of-range -> i > length branch
    ))
  ))
  msg <- list(data = list(dataSets = list(ds), structures = list(st)))
  out <- parse_imf_sdmx_json(msg)
  expect_equal(nrow(out), 2L)
  expect_true(all(is.na(out$TIME_PERIOD)))
})


