# Changelog

## imfapi 0.1.2

CRAN release: 2025-11-19

- Examples that make 3rd-party API calls now skip CRAN tests to avoid
  CRAN check failures.

## imfapi 0.1.1

CRAN release: 2025-10-30

- [`imf_get()`](https://teal-insights.github.io/r-imfapi/reference/imf_get.md)
  now returns a non-empty dataframe when `start_period` and/or
  `end_period` filters are applied to valid annual frequency queries.

## imfapi 0.1.0

CRAN release: 2025-10-25

- Initial CRAN submission with
  [`imf_get_dataflows()`](https://teal-insights.github.io/r-imfapi/reference/imf_get_dataflows.md),
  [`imf_get_datastructure()`](https://teal-insights.github.io/r-imfapi/reference/imf_get_datastructure.md),
  [`imf_get_codelists()`](https://teal-insights.github.io/r-imfapi/reference/imf_get_codelists.md),
  and
  [`imf_get()`](https://teal-insights.github.io/r-imfapi/reference/imf_get.md).
