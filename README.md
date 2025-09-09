
# imfapi

<!-- badges: start -->

[![R-CMD-check](https://github.com/Teal-Insights/r-imfapi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Teal-Insights/r-imfapi/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/Teal-Insights/r-imfapi/graph/badge.svg)](https://app.codecov.io/gh/Teal-Insights/r-imfapi)
<!-- badges: end -->

## Installation

``` r
install.packages("imfapi")
```

## Usage

``` r
library(imfapi)
```

### Get datasets

``` r
imf_get_dataflows() |>
  head() |>
  # Note: We use a custom helper function to truncate long strings in columns
  truncate_text(max_chars = 10) |>
  knitr::kable()
```

| id       | name        | description | version | structure     | last_updated |
|:---------|:------------|:------------|:--------|:--------------|:-------------|
| IIPCC    | Currency C… | The Curren… | 13.0.0  | <urn:sdmx:o>… | 2025-06-03…  |
| FSICDM   | Financial … | The Financ… | 7.0.0   | <urn:sdmx:o>… | 2025-05-07…  |
| ICSD     | Investment… | This datas… | 1.0.0   | <urn:sdmx:o>… | 2025-04-21…  |
| QGDP_WCA | Quarterly … | This datas… | 3.0.0   | <urn:sdmx:o>… | 2025-08-01…  |
| EER      | Effective … | The Effect… | 6.0.0   | <urn:sdmx:o>… | 2025-03-28…  |
| FSIBSIS  | Financial … | The Financ… | 18.0.0  | <urn:sdmx:o>… | 2025-07-01…  |

### Get datastructure dimensions

``` r
imf_get_datastructure("GFS", include_time = TRUE, include_measures = TRUE) |>
  knitr::kable()
```

| dimension_id           | type          | position |
|:-----------------------|:--------------|---------:|
| COUNTRY                | Dimension     |        0 |
| SECTOR                 | Dimension     |        1 |
| GFS_GRP                | Dimension     |        2 |
| INDICATOR              | Dimension     |        3 |
| TYPE_OF_TRANSFORMATION | Dimension     |        4 |
| FREQUENCY              | Dimension     |        5 |
| TIME_PERIOD            | TimeDimension |        6 |
| OBS_VALUE              | Measure       |       NA |

### Get codelists for dimensions we want to filter on

``` r
imf_get_codelists(c("COUNTRY")) |>
  head() |>
  # Note: We use a custom helper function to truncate long strings in columns
  truncate_text(max_chars = 10) |>
  knitr::kable()
```

### Get data

``` r
imf_get_data("GFS", "MFS_IR")
```
