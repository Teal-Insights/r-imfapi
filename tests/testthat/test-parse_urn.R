testthat::test_that("first_scalar handles edge cases and common inputs", {
  # NULL value -> NA_character
  testthat::expect_identical(first_scalar(NULL), NA_character_)

  # Empty list -> NA_character_
  testthat::expect_identical(first_scalar(list()), NA_character_)

  # List containing empty vector -> NA_character_
  testthat::expect_identical(first_scalar(list(character(0))), NA_character_)

  # Simple list of scalars -> first element
  testthat::expect_identical(first_scalar(list("a", "b")), "a")

  # Nested list is flattened -> first leaf element
  testthat::expect_identical(first_scalar(list(list("x", "y"), "z")), "x")

  # Atomic vectors -> coerced to character of first element
  testthat::expect_identical(first_scalar(c(2, 3)), "2")
  testthat::expect_identical(first_scalar(c(TRUE, FALSE)), "TRUE")

  # Zero-length atomic vector -> NA_character_
  testthat::expect_identical(first_scalar(character(0)), NA_character_)
})

testthat::test_that("parse_concept_urn parses valid URNs, fails gracefully", {
  valid <- paste0(
    "urn:sdmx:org.sdmx.infomodel.conceptscheme.",
    "Concept=IMF.MCD:CS_MCDREO(7.0.0).COUNTRY"
  )
  got <- parse_concept_urn(valid)
  testthat::expect_equal(got$agency, "IMF.MCD")
  testthat::expect_equal(got$scheme, "CS_MCDREO")
  testthat::expect_equal(got$version, "7.0.0")
  testthat::expect_equal(got$concept, "COUNTRY")

  # Also works when provided as a list (first element is taken)
  got_list <- parse_concept_urn(list(valid, "ignored"))
  testthat::expect_equal(got_list, got)

  # Invalid URN -> all NA_character_
  invalid <- parse_concept_urn("urn:sdmx:foo")
  testthat::expect_true(all(vapply(invalid, is.character, logical(1))))
  testthat::expect_true(all(is.na(unlist(invalid, use.names = FALSE))))

  # NULL input -> NA fields via first_scalar
  null_in <- parse_concept_urn(NULL)
  testthat::expect_true(all(is.na(unlist(null_in, use.names = FALSE))))
})

testthat::test_that("parse_codelist_urn handles both Codelist and CodeList", {
  # Real example (Codelist)
  urn_codelist <- paste0(
    "urn:sdmx:org.sdmx.infomodel.codelist.",
    "Codelist=IMF.STA.DS:CL_DQAF_CPI_MONTH(1.0.0)"
  )
  got1 <- parse_codelist_urn(urn_codelist)
  testthat::expect_equal(got1$agency, "IMF.STA.DS")
  testthat::expect_equal(got1$id, "CL_DQAF_CPI_MONTH")
  testthat::expect_equal(got1$version, "1.0.0")

  # Synthetic variant (CodeList)
  urn_codelist2 <- sub(
    "codelist.Codelist", "codelist.CodeList", urn_codelist, fixed = TRUE
  )
  got2 <- parse_codelist_urn(urn_codelist2)
  testthat::expect_equal(got2, got1)

  # Failure case -> NA fields
  fail <- parse_codelist_urn(
    "urn:sdmx:org.sdmx.infomodel.codelist.Code=IMF:FOO(1.0.0).BAR"
  )
  testthat::expect_true(all(is.na(unlist(fail, use.names = FALSE))))
})

testthat::test_that("parse_datastructure_urn parses valid DataStructure URN", {
  urn_dsd <- paste0(
    "urn:sdmx:org.sdmx.infomodel.datastructure.",
    "DataStructure=IMF.FAD:DSD_HPD(1.0.0)"
  )
  got <- parse_datastructure_urn(urn_dsd)
  testthat::expect_equal(got$agency, "IMF.FAD")
  testthat::expect_equal(got$id, "DSD_HPD")
  testthat::expect_equal(got$version, "1.0.0")

  # Non-matching -> NA fields
  bad <- parse_datastructure_urn(
    paste0(
      "urn:sdmx:org.sdmx.infomodel.datastructure.",
      "Dimension=IMF.FAD:DSD_HPD(1.0.0).COUNTRY"
    )
  )
  testthat::expect_true(all(is.na(unlist(bad, use.names = FALSE))))
})
