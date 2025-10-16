test_that("resource must be a non-empty character scalar", {
  expect_error(
    perform_request(
      resource = 1,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "must be a non-empty character scalar"
  )
  expect_error(
    perform_request(
      resource = c("a", "b"),
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "must be a non-empty character scalar"
  )
  expect_error(
    perform_request(
      resource = NA_character_,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "must be a non-empty character scalar"
  )
  expect_error(
    perform_request(
      resource = "   ",
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "must be a non-empty character scalar"
  )
})

test_that("resource must be a path (not a full URL)", {
  expect_error(
    perform_request(
      resource = "https://api.imf.org/external/sdmx/3.0/",
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "should be a path"
  )
})

test_that("progress must be a single non-missing logical", {
  expect_error(
    perform_request(
      "structure", progress = c(TRUE, FALSE),
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "progress.*single non-missing logical"
  )
  expect_error(
    perform_request(
      "structure", progress = "yes",
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "progress.*single non-missing logical"
  )
})

test_that("cache must be a single non-missing logical", {
  expect_error(
    perform_request(
      "structure", cache = c(TRUE, FALSE),
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "cache.*single non-missing logical"
  )
  expect_error(
    perform_request(
      "structure", cache = "yes",
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "cache.*single non-missing logical"
  )
})

test_that("max_tries must be a positive whole number", {
  expect_error(
    perform_request(
      "structure", max_tries = NA,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", max_tries = Inf,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", max_tries = -1,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", max_tries = c(1, 2),
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", max_tries = "3",
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", max_tries = 1.5,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
})

test_that("timeout_seconds must be a positive whole number", {
  expect_error(
    perform_request(
      "structure", timeout_seconds = NA,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", timeout_seconds = Inf,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", timeout_seconds = 0,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", timeout_seconds = -1,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", timeout_seconds = c(1, 2),
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", timeout_seconds = "3",
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
})

test_that("low_speed_seconds must be a positive whole number", {
  expect_error(
    perform_request(
      "structure", low_speed_seconds = NA,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", low_speed_seconds = Inf,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", low_speed_seconds = 0,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", low_speed_seconds = -1,
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", low_speed_seconds = c(1, 2),
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
  expect_error(
    perform_request(
      "structure", low_speed_seconds = "3",
      base_url = "https://api.imf.org/external/sdmx/3.0/"
    ),
    regexp = "positive whole number"
  )
})

test_that("build pipeline calls expected httr2 functions", {
  calls <- character()
  env <- new.env(parent = emptyenv())
  env$calls <- character()
  env$base_url <- NULL
  env$resource <- NULL
  env$headers <- NULL
  env$max_tries <- NULL
  env$last_query <- NULL
  env$response <- list()
  env$resp_status <- 200L
  env$content_type <- "application/json"
  env$body_json <- list(ok = TRUE)
  env$body_string <- "{}"

  fake_req <- function() structure(list(tag = "req"), class = "fake_req")

  fake_resp <- function() structure(list(tag = "resp"), class = "fake_resp")

  testthat::local_mocked_bindings(
    # request building
    request = function(base_url) {
      env$base_url <- base_url
      env$calls <- c(env$calls, "request")
      fake_req()
    },
    req_url_path_append = function(req, resource) {
      env$resource <- resource
      env$calls <- c(env$calls, "req_url_path_append")
      req
    },
    req_headers = function(req, ...) {
      env$headers <- list(...)
      env$calls <- c(env$calls, "req_headers")
      req
    },
    req_retry = function(req, max_tries = NULL, ...) {
      env$max_tries <- max_tries
      env$calls <- c(env$calls, "req_retry")
      req
    },
    req_error = function(req, ...) req,
    req_timeout = function(req, ...) {
      env$calls <- c(env$calls, "req_timeout")
      req
    },
    req_options = function(req, ...) {
      env$calls <- c(env$calls, "req_options")
      req
    },
    req_url_query = function(req, ...) {
      env$last_query <- list(...)
      env$calls <- c(env$calls, "req_url_query")
      req
    },
    req_cache = function(req, ...) {
      env$calls <- c(env$calls, "req_cache")
      req
    },
    req_progress = function(req, ...) {
      env$calls <- c(env$calls, "req_progress")
      req
    },
    # perform and response helpers
    req_perform = function(req, ...) {
      env$calls <- c(env$calls, "req_perform")
      fake_resp()
    },
    resp_status = function(resp) env$resp_status,
    resp_header = function(resp, name) {
      if (identical(name, "content-type")) env$content_type else NULL
    },
    resp_body_json = function(resp) env$body_json,
    resp_body_string = function(resp) env$body_string,
    .package = "httr2"
  )

  out <- perform_request(
    resource = "structure/dataflow",
    base_url = "https://api.imf.org/external/sdmx/3.0/",
    query_params = list(references = "none", offset = "0", limit = "5"),
    progress = FALSE,
    max_tries = 7L,
    cache = TRUE
  )

  expect_true(is.list(out))
  expect_identical(env$base_url, "https://api.imf.org/external/sdmx/3.0/")
  expect_identical(env$resource, "structure/dataflow")
  expect_type(env$headers, "list")
  expect_identical(env$headers$`Accept`, "application/json")
  expect_match(env$headers$`User-Agent`, "imfapi R package", fixed = FALSE)
  expect_identical(env$max_tries, 7L)
  expect_identical(env$last_query$references, "none")
  expect_identical(env$last_query$offset, "0")
  expect_identical(env$last_query$limit, "5")

  # req_progress should NOT be called when progress = FALSE
  expect_false("req_progress" %in% env$calls)

  # Ensure the core chain happened in expected order subset
  subset <- c(
    "request", "req_url_path_append", "req_headers", "req_retry",
    "req_url_query", "req_cache", "req_perform"
  )
  expect_setequal(intersect(env$calls, subset), subset)
})

test_that("progress = TRUE calls req_progress", {
  env <- new.env(parent = emptyenv())
  env$calls <- character()
  env$resp_status <- 200L
  env$content_type <- "application/json"
  env$body_json <- list(ok = TRUE)

  fake_req <- function() structure(list(tag = "req"), class = "fake_req")
  fake_resp <- function() structure(list(tag = "resp"), class = "fake_resp")

  testthat::local_mocked_bindings(
    request = function(base_url) {
      env$calls <- c(env$calls, "request")
      fake_req()
    },
    req_url_path_append = function(req, resource) {
      env$calls <- c(env$calls, "req_url_path_append")
      req
    },
    req_headers = function(req, ...) {
      env$calls <- c(env$calls, "req_headers")
      req
    },
    req_retry = function(req, ...) {
      env$calls <- c(env$calls, "req_retry")
      req
    },
    req_error = function(req, ...) req,
    req_timeout = function(req, ...) {
      env$calls <- c(env$calls, "req_timeout")
      req
    },
    req_options = function(req, ...) {
      env$calls <- c(env$calls, "req_options")
      req
    },
    req_progress = function(req, ...) {
      env$calls <- c(env$calls, "req_progress")
      req
    },
    req_perform = function(req, ...) {
      env$calls <- c(env$calls, "req_perform")
      fake_resp()
    },
    resp_status = function(resp) env$resp_status,
    resp_header = function(resp, name) env$content_type,
    resp_body_json = function(resp) env$body_json,
    .package = "httr2"
  )

  out <- perform_request(
    resource = "structure/",
    base_url = "https://api.imf.org/external/sdmx/3.0/",
    progress = TRUE,
    cache = FALSE
  )

  expect_true(is.list(out))
  expect_true("req_progress" %in% env$calls)
})

test_that("HTTP >= 400 parses JSON error and aborts", {
  env <- new.env(parent = emptyenv())
  env$calls <- character()
  env$resp_status <- 404L
  env$content_type <- "application/json"
  env$body_string <- jsonlite::toJSON(list(
    message = "Not Found",
    code = "NOT_FOUND",
    correlationId = "abc-123",
    path = "/bad/path"
  ), auto_unbox = TRUE)

  fake_req <- function() structure(list(tag = "req"), class = "fake_req")
  fake_resp <- function() structure(list(tag = "resp"), class = "fake_resp")

  testthat::local_mocked_bindings(
    request = function(base_url) fake_req(),
    req_url_path_append = function(req, resource) req,
    req_headers = function(req, ...) req,
    req_retry = function(req, ...) req,
    req_error = function(req, ...) req,
    req_timeout = function(req, ...) req,
    req_options = function(req, ...) req,
    req_perform = function(req, ...) fake_resp(),
    resp_status = function(resp) env$resp_status,
    resp_body_string = function(resp) env$body_string,
    .package = "httr2"
  )

  expect_error(
    perform_request(
      resource = "nope",
      base_url = "https://api.imf.org/external/sdmx/3.0/",
      cache = FALSE
    ),
    regexp = "status=404"
  )
})

test_that("falls back to parsing JSON from text when content-type not JSON", {
  env <- new.env(parent = emptyenv())
  env$resp_status <- 200L
  env$content_type <- "text/plain"
  env$body_string <- jsonlite::toJSON(list(answer = 42), auto_unbox = TRUE)

  fake_req <- function() structure(list(tag = "req"), class = "fake_req")
  fake_resp <- function() structure(list(tag = "resp"), class = "fake_resp")

  testthat::local_mocked_bindings(
    request = function(base_url) fake_req(),
    req_url_path_append = function(req, resource) req,
    req_headers = function(req, ...) req,
    req_retry = function(req, ...) req,
    req_error = function(req, ...) req,
    req_timeout = function(req, ...) req,
    req_options = function(req, ...) req,
    req_perform = function(req, ...) fake_resp(),
    resp_status = function(resp) env$resp_status,
    resp_header = function(resp, name) env$content_type,
    resp_body_string = function(resp) env$body_string,
    .package = "httr2"
  )

  out <- perform_request(
    resource = "structure/",
    base_url = "https://api.imf.org/external/sdmx/3.0/",
    cache = FALSE
  )

  expect_true(is.list(out))
  expect_equal(out$answer, 42)
})

test_that("unexpected non-JSON content produces informative error", {
  env <- new.env(parent = emptyenv())
  env$resp_status <- 200L
  env$content_type <- "text/html"
  env$body_string <- "<html>oops</html>"

  fake_req <- function() structure(list(tag = "req"), class = "fake_req")
  fake_resp <- function() structure(list(tag = "resp"), class = "fake_resp")

  testthat::local_mocked_bindings(
    request = function(base_url) fake_req(),
    req_url_path_append = function(req, resource) req,
    req_headers = function(req, ...) req,
    req_retry = function(req, ...) req,
    req_error = function(req, ...) req,
    req_timeout = function(req, ...) req,
    req_options = function(req, ...) req,
    req_perform = function(req, ...) fake_resp(),
    resp_status = function(resp) env$resp_status,
    resp_header = function(resp, name) env$content_type,
    resp_body_string = function(resp) env$body_string,
    .package = "httr2"
  )

  expect_error(
    perform_request(
      resource = "structure/",
      base_url = "https://api.imf.org/external/sdmx/3.0/",
      cache = FALSE
    ),
    regexp = "Unexpected content type"
  )
})

test_that("HTTP error with empty message uses default 'HTTP error'", {
  env <- new.env(parent = emptyenv())
  env$resp_status <- 500L
  env$body_string <- jsonlite::toJSON(list(
    message = "",
    code = "E500",
    correlationId = "corr-xyz",
    path = "/oops"
  ), auto_unbox = TRUE)

  fake_req <- function() structure(list(tag = "req"), class = "fake_req")
  fake_resp <- function() structure(list(tag = "resp"), class = "fake_resp")

  testthat::local_mocked_bindings(
    request = function(base_url) fake_req(),
    req_url_path_append = function(req, resource) req,
    req_headers = function(req, ...) req,
    req_retry = function(req, ...) req,
    req_error = function(req, ...) req,
    req_timeout = function(req, ...) req,
    req_options = function(req, ...) req,
    req_perform = function(req, ...) fake_resp(),
    resp_status = function(resp) env$resp_status,
    resp_body_string = function(resp) env$body_string,
    .package = "httr2"
  )

  expect_error(
    perform_request(
      resource = "structure/",
      base_url = "https://api.imf.org/external/sdmx/3.0/",
      cache = FALSE
    ),
    regexp = "HTTP error.*status=500"
  )
})

test_that("query params are accepted and request succeeds (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()
  res <- perform_request(
    resource = "structure/dataflow",
    base_url = "https://api.imf.org/external/sdmx/3.0/",
    query_params = list(references = "none", offset = "0", limit = "5")
  )
  expect_true(is.list(res))
})

test_that("progress path executes (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()
  res <- perform_request(
    resource = "structure/codelist",
    base_url = "https://api.imf.org/external/sdmx/3.0/",
    progress = TRUE,
    query_params = list(limit = "1")
  )
  expect_true(is.list(res))
})

test_that("non-existent resource yields informative HTTP error (live)", {
  skip_on_cran()
  skip_on_ci()
  skip_if_offline()
  expect_error(
    perform_request(
      resource = "no-such-resource-xyz",
      base_url = "https://api.imf.org/external/sdmx/3.0/",
      timeout_seconds = 5L,
      low_speed_seconds = 3L,
      max_tries = 1L
    ),
    regexp = "(status=|[Tt]imeout|Operation too slow)"
  )
})
