test_that("imf_get_codelists maps codes across dimensions", {
  # We'll mock get_datastructure_components to return dimensions with
  # conceptIdentity and localRepresentation.enumeration and then mock
  # perform_request for conceptscheme and codelist endpoints.
  calls <- list()

  # Simulate datastructure components for two dimensions
  ds_components <- list(
    dimensionList = list(
      dimensions = list(
        list(
          id = "FREQ",
          type = "Dimension",
          position = 1L,
          conceptIdentity = list(
            paste0(
              "urn:sdmx:org.sdmx.infomodel.conceptscheme",
              ".Concept=IMF:CS(1.0.0).FREQ"
            )
          ),
          localRepresentation = list(
            enumeration = list(
              "urn:sdmx:org.sdmx.infomodel.codelist.CodeList=IMF:CL_FREQ(1.0.0)"
            )
          )
        ),
        list(
          id = "COUNTRY",
          type = "Dimension",
          position = 2L,
          conceptIdentity = list(
            paste0(
              "urn:sdmx:org.sdmx.infomodel.conceptscheme",
              ".Concept=IMF:COUNTRY(1.0.0).COUNTRY"
            )
          ),
          localRepresentation = list(
            enumeration = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.codelist",
                ".Codelist=IMF:CL_COUNTRY(1.0.0)"
              )
            )
          )
        )
      ),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  # Conceptscheme response containing concept entries
  conceptscheme_body <- list(
    data = list(
      conceptSchemes = list(
        list(
          concepts = list(
            list(id = list("FREQ"), coreRepresentation = list(
              enumeration = list(
                paste0(
                  "urn:sdmx:org.sdmx.infomodel.codelist",
                  ".CodeList=IMF:CL_FREQ(1.0.0)"
                )
              )
            )),
            list(id = list("COUNTRY"), coreRepresentation = list(
              enumeration = list(
                paste0(
                  "urn:sdmx:org.sdmx.infomodel.codelist",
                  ".Codelist=IMF:CL_COUNTRY(1.0.0)"
                )
              )
            ))
          )
        )
      )
    )
  )

  # Codelist responses
  codelist_freq_body <- list(
    data = list(
      codelists = list(
        list(
          codes = list(
            list(
              id = list("A"), name = list("Annual"),
              description = list("Annual frequency")
            ),
            list(
              id = list("Q"), name = list("Quarterly"),
              description = list("Quarterly frequency")
            )
          )
        )
      )
    )
  )
  codelist_country_body <- list(
    data = list(
      codelists = list(
        list(
          codes = list(
            list(
              id = list("US"), name = list("United States"),
              description = list("United States of America")
            ),
            list(
              id = list("DE"), name = list("Germany"),
              description = list("Federal Republic of Germany")
            )
          )
        )
      )
    )
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      calls <<- append(calls, list(list(
        fun = "get_datastructure_components", dataflow_id = dataflow_id,
        progress = progress, max_tries = max_tries, cache = cache
      )))
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      calls <<- append(calls, list(list(
        fun = "perform_request", resource = resource, progress = progress,
        max_tries = max_tries, cache = cache
      )))
      if (grepl("^structure/conceptscheme/", resource)) {
        return(conceptscheme_body)
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(codelist_freq_body)
      }
      if (grepl("codelist/.*/CL_COUNTRY", resource)) {
        return(codelist_country_body)
      }
      stop("Unexpected resource in mock: ", resource)
    },
    .package = "imfapi"
  )

  out <- imf_get_codelists(
    c("FREQ", "COUNTRY"), dataflow_id = "MFS_IR", progress = TRUE,
    max_tries = 5L, cache = FALSE
  )

  expect_s3_class(out, "tbl_df")
  expect_true(all(
    c(
      "dimension_id", "code", "name", "description", "codelist_id",
      "codelist_agency", "codelist_version"
    ) %in% names(out)
  ))
  expect_true(all(out$dimension_id %in% c("FREQ", "COUNTRY")))

  # Check a couple of concrete values
  freq_rows <- out[out$dimension_id == "FREQ", ]
  expect_true(any(freq_rows$code == "A" & grepl("Annual", freq_rows$name)))
  expect_true(any(freq_rows$code == "Q"))

  country_rows <- out[out$dimension_id == "COUNTRY", ]
  expect_true(any(
    country_rows$code == "US" & grepl("United States", country_rows$name)
  ))
  expect_true(any(country_rows$code == "DE"))
})

test_that("unknown requested dimension is skipped (entry == NULL)", {
  # Datastructure has only FREQ, request includes UNKNOWN which we skip
  ds_components <- list(
    dimensionList = list(
      dimensions = list(list(
        id = "FREQ",
        conceptIdentity = list(
          paste0(
            "urn:sdmx:org.sdmx.infomodel.conceptscheme",
            ".Concept=IMF:CS(1.0.0).FREQ"
          )
        ),
        localRepresentation = list(enumeration = list(
          paste0(
            "urn:sdmx:org.sdmx.infomodel.codelist",
            ".CodeList=IMF:CL_FREQ(1.0.0)"
          )
        ))
      )),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/", resource)) {
        return(list(data = list(conceptSchemes = list(list(concepts = list(
          list(id = list("FREQ"), coreRepresentation = list(
            enumeration = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.codelist",
                ".CodeList=IMF:CL_FREQ(1.0.0)"
              )
            )
          ))
        ))))))
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(list(data = list(codelists = list(list(codes = list(list(
          id = list("A"), name = list("Annual"), description = list("Annual")
        )))))))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  out <- imf_get_codelists(c("FREQ", "UNKNOWN"), dataflow_id = "X")
  expect_s3_class(out, "tbl_df")
  expect_true(all(out$dimension_id == "FREQ"))
})

test_that("null concepts in conceptscheme are skipped (cands is NULL)", {
  ds_components <- list(
    dimensionList = list(
      dimensions = list(list(
        id = "FREQ",
        conceptIdentity = list(
          paste0(
            "urn:sdmx:org.sdmx.infomodel.conceptscheme",
            ".Concept=IMF:CS(1.0.0).FREQ"
          )
        ),
        localRepresentation = list(enumeration = list(
          paste0(
            "urn:sdmx:org.sdmx.infomodel.codelist",
            ".CodeList=IMF:CL_FREQ(1.0.0)"
          )
        ))
      )),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/", resource)) {
        return(list(data = list(conceptSchemes = list(list(concepts = NULL)))))
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(list(data = list(codelists = list(list(codes = list(list(
          id = list("A"), name = list("Annual"), description = list("Annual")
        )))))))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  out <- imf_get_codelists("FREQ", dataflow_id = "X")
  expect_s3_class(out, "tbl_df")
  expect_true(nrow(out) == 1)
})

test_that("empty enumeration short-circuits (enum_urn empty -> return NULL)", {
  ds_components <- list(
    dimensionList = list(
      dimensions = list(list(
        id = "FREQ",
        conceptIdentity = list(
          paste0(
            "urn:sdmx:org.sdmx.infomodel.conceptscheme",
            ".Concept=IMF:CS(1.0.0).FREQ"
          )
        ),
        localRepresentation = list(enumeration = list(""))
      )),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/", resource)) {
        return(list(data = list(conceptSchemes = list(list(concepts = list(
          list(id = list("FREQ"), coreRepresentation = list())
        ))))))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  out <- imf_get_codelists("FREQ", dataflow_id = "X")
  # No rows should be returned since enumeration is empty and dimension skipped
  expect_s3_class(out, "tbl_df")
  expect_true(nrow(out) == 0)
})

test_that("codelist-not-found error is thrown when both paths fail", {
  ds_components <- list(
    dimensionList = list(
      dimensions = list(list(
        id = "FREQ",
        conceptIdentity = list(
          paste0(
            "urn:sdmx:org.sdmx.infomodel.conceptscheme",
            ".Concept=IMF:CS(1.0.0).FREQ"
          )
        ),
        localRepresentation = list(enumeration = list(
          paste0(
            "urn:sdmx:org.sdmx.infomodel.codelist",
            ".CodeList=IMF:CL_FREQ(1.0.0)"
          )
        ))
      )),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/", resource)) {
        return(list(data = list(conceptSchemes = list(list(concepts = list(
          list(id = list("FREQ"), coreRepresentation = list(
            enumeration = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.codelist",
                ".CodeList=IMF:CL_FREQ(1.0.0)"
              )
            )
          ))
        ))))))
      }
      if (grepl("^structure/codelist/IMF/CL_FREQ/\\+", resource)) {
        stop("404")
      }
      if (grepl("^structure/codelist/all/CL_FREQ/\\+", resource)) {
        stop("404")
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  expect_error(
    imf_get_codelists("FREQ", dataflow_id = "X"),
    regexp = "Codelist CL_FREQ not found"
  )
})
test_that("imf_get_codelists propagates args for conceptscheme and codelist", {
  last_calls <- list()
  calls <- list()

  ds_components <- list(
    dimensionList = list(
      dimensions = list(
        list(
          id = "FREQ",
          conceptIdentity = list(
            paste0(
              "urn:sdmx:org.sdmx.infomodel.conceptscheme",
              ".Concept=IMF:CS(1.0.0).FREQ"
            )
          ),
          localRepresentation = list(enumeration = list(
            paste0(
              "urn:sdmx:org.sdmx.infomodel.codelist",
              ".CodeList=IMF:CL_FREQ(1.0.0)"
            )
          ))
        )
      ),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      calls <<- append(calls, list(list(
        fun = "get_datastructure_components", dataflow_id = dataflow_id,
        progress = progress, max_tries = max_tries, cache = cache
      )))
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      last_calls <<- append(last_calls, list(list(
        resource = resource,
        progress = progress,
        max_tries = max_tries,
        cache = cache
      )))
      if (grepl("^structure/conceptscheme/", resource)) {
        return(list(
          data = list(
            conceptSchemes = list(list(
              concepts = list(list(
                id = list("FREQ"),
                coreRepresentation = list(enumeration = list(
                  paste0(
                    "urn:sdmx:org.sdmx.infomodel.codelist",
                    ".CodeList=IMF:CL_FREQ(1.0.0)"
                  )
                ))
              ))
            ))
          )
        ))
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(list(
          data = list(codelists = list(list(
            codes = list(list(
              id = list("A"),
              name = list("Annual"),
              description = list("Annual")
            ))
          )))
        ))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  out <- imf_get_codelists(
    "FREQ",
    dataflow_id = "X",
    progress = TRUE,
    max_tries = 7L,
    cache = FALSE
  )
  expect_s3_class(out, "tbl_df")
  # We expect at least two perform_request calls: conceptscheme and codelist
  expect_true(length(last_calls) >= 2)
  for (lc in last_calls) {
    expect_identical(lc$progress, TRUE)
    expect_identical(lc$max_tries, 7L)
    expect_identical(lc$cache, FALSE)
  }
})

test_that("imf_get_codelists errors when conceptscheme cannot be resolved", {
  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      list(
        dimensionList = list(
          dimensions = list(list(
            id = "FREQ",
            conceptIdentity = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.conceptscheme",
                ".Concept=IMF:CS(1.0.0).FREQ"
              )
            ),
            localRepresentation = list(enumeration = list(""))
          )),
          timeDimensions = list()
        ),
        measureList = list(measures = list())
      )
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      # Simulate both agency-specific and all/* paths failing -> NULL
      stop("404")
    },
    .package = "imfapi"
  )

  expect_error(
    imf_get_codelists("FREQ", dataflow_id = "X"),
    regexp = "Conceptscheme not found"
  )
})

test_that("imf_get_codelists errors when codelist payload missing or empty", {
  # Return a concept but make the codelist response empty
  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      list(
        dimensionList = list(
          dimensions = list(list(
            id = "FREQ",
            conceptIdentity = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.conceptscheme",
                ".Concept=IMF:CS(1.0.0).FREQ"
              )
            ),
            localRepresentation = list(enumeration = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.codelist",
                ".CodeList=IMF:CL_FREQ(1.0.0)"
              )
            ))
          )),
          timeDimensions = list()
        ),
        measureList = list(measures = list())
      )
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/", resource)) {
        return(list(
          data = list(
            conceptSchemes = list(
              list(concepts = list(
                list(
                  id = list("FREQ"),
                  coreRepresentation = list(enumeration = list(
                    paste0(
                      "urn:sdmx:org.sdmx.infomodel.codelist",
                      ".CodeList=IMF:CL_FREQ(1.0.0)"
                    )
                  ))
                )
              ))
            )
          )
        ))
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(list(data = list(codelists = list())))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  expect_error(
    imf_get_codelists("FREQ", dataflow_id = "X"),
    regexp = "Empty codelists payload"
  )
})

test_that("imf_get_codelists live smoke test (guarded)", {
  skip_on_cran()
  skip_if_offline()
  skip("Temporarily skipped due to upstream conceptscheme instability")
  # This will hit the actual API; use a small dimension set
  out <- imf_get_codelists(
    c("FREQ"), dataflow_id = "MFS_IR", progress = FALSE,
    max_tries = 3L, cache = TRUE
  )
  expect_s3_class(out, "tbl_df")
  expect_true(nrow(out) >= 1)
  expect_true(all(c("dimension_id", "code", "name") %in% names(out)))
})

test_that("imf_get_codelists validates arguments", {
  # dimension_ids must be non-empty character vector
  expect_error(imf_get_codelists(character(0), dataflow_id = "X"),
               regexp = "dimension_ids.*non-empty character vector")
  expect_error(imf_get_codelists(c("FREQ", NA_character_), dataflow_id = "X"),
               regexp = "must not contain")
  expect_error(imf_get_codelists(c("FREQ", "   "), dataflow_id = "X"),
               regexp = "must not contain")
  # dataflow_id must be non-empty character scalar
  expect_error(imf_get_codelists("FREQ", dataflow_id = c("A", "B")),
               regexp = "dataflow_id.*non-empty character scalar")
  expect_error(imf_get_codelists("FREQ", dataflow_id = "   "),
               regexp = "dataflow_id.*non-empty character scalar")
})

test_that("conceptscheme agency path fails then all/* succeeds (fallback)", {
  ds_components <- list(
    dimensionList = list(
      dimensions = list(list(
        id = "FREQ",
        conceptIdentity = list(
          "urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept=IMF:CS(1.0.0).FREQ"
        ),
        localRepresentation = list(enumeration = list(
          "urn:sdmx:org.sdmx.infomodel.codelist.CodeList=IMF:CL_FREQ(1.0.0)"
        ))
      )),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/IMF/CS/\\+", resource)) {
        stop("404") # agency path fails
      }
      if (grepl("^structure/conceptscheme/all/CS/\\+", resource)) {
        return(list(data = list(conceptSchemes = list(list(concepts = list(
          list(id = list("FREQ"), coreRepresentation = list(
            enumeration = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.codelist",
                ".CodeList=IMF:CL_FREQ(1.0.0)"
              )
            )
          ))
        ))))))
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(list(data = list(codelists = list(list(codes = list(list(
          id = list("A"), name = list("Annual"), description = list("Annual")
        )))))))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  out <- imf_get_codelists("FREQ", dataflow_id = "X")
  expect_s3_class(out, "tbl_df")
  expect_true(nrow(out) >= 1)
})

test_that("local enum fallback used when concept has no enumeration", {
  ds_components <- list(
    dimensionList = list(
      dimensions = list(list(
        id = "FREQ",
        conceptIdentity = list(
          "urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept=IMF:CS(1.0.0).FREQ"
        ),
        localRepresentation = list(enumeration = list(
          "urn:sdmx:org.sdmx.infomodel.codelist.CodeList=IMF:CL_FREQ(1.0.0)"
        ))
      )),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/", resource)) {
        # Return concept without enumeration to force local enum fallback
        return(list(data = list(conceptSchemes = list(list(concepts = list(
          list(id = list("FREQ"), coreRepresentation = list())
        ))))))
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(list(data = list(codelists = list(list(codes = list(list(
          id = list("A"), name = list("Annual"), description = list("Annual")
        )))))))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  out <- imf_get_codelists("FREQ", dataflow_id = "X")
  expect_s3_class(out, "tbl_df")
  expect_true(nrow(out) == 1)
  expect_identical(out$codelist_id[[1]], "CL_FREQ")
  expect_identical(out$codelist_agency[[1]], "IMF")
})

test_that("error when codelist has NULL codes", {
  ds_components <- list(
    dimensionList = list(
      dimensions = list(list(
        id = "FREQ",
        conceptIdentity = list(
          "urn:sdmx:org.sdmx.infomodel.conceptscheme.Concept=IMF:CS(1.0.0).FREQ"
        ),
        localRepresentation = list(enumeration = list(
          "urn:sdmx:org.sdmx.infomodel.codelist.CodeList=IMF:CL_FREQ(1.0.0)"
        ))
      )),
      timeDimensions = list()
    ),
    measureList = list(measures = list())
  )

  testthat::local_mocked_bindings(
    get_datastructure_components = function(
      dataflow_id, progress, max_tries, cache
    ) {
      ds_components
    },
    perform_request = function(resource, progress, max_tries, cache, ...) {
      if (grepl("^structure/conceptscheme/", resource)) {
        return(list(data = list(conceptSchemes = list(list(concepts = list(
          list(id = list("FREQ"), coreRepresentation = list(
            enumeration = list(
              paste0(
                "urn:sdmx:org.sdmx.infomodel.codelist",
                ".CodeList=IMF:CL_FREQ(1.0.0)"
              )
            )
          ))
        ))))))
      }
      if (grepl("codelist/.*/CL_FREQ", resource)) {
        return(list(data = list(codelists = list(list(codes = NULL)))))
      }
      stop("unexpected resource: ", resource)
    },
    .package = "imfapi"
  )

  expect_error(
    imf_get_codelists("FREQ", dataflow_id = "X"),
    regexp = "No codes found in codelist"
  )
})
