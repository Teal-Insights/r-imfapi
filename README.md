
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

| id      | name        | description | version | agency  | last_updated |
|:--------|:------------|:------------|:--------|:--------|:-------------|
| FSIBSIS | Financial … | The Financ… | 18.0.0  | IMF.STA | 2025-07-01…  |
| FM      | Fiscal Mon… | The Fiscal… | 5.0.0   | IMF.FAD | 2025-03-28…  |
| EER     | Effective … | The Effect… | 6.0.0   | IMF.STA | 2025-03-28…  |
| ITG     | Internatio… | Trade in g… | 4.0.0   | IMF.STA | 2025-03-28…  |
| IIPCC   | Currency C… | The Curren… | 13.0.0  | IMF.STA | 2025-06-03…  |
| PSBS    | Public Sec… | The Public… | 2.0.0   | IMF.FAD | 2025-04-23…  |

### Get datastructure dimensions

``` r
imf_get_datastructure(
  "PPI", include_time = TRUE, include_measures = TRUE
) |>
  knitr::kable()
```

| dimension_id           | type          | position |
|:-----------------------|:--------------|---------:|
| COUNTRY                | Dimension     |        0 |
| INDICATOR              | Dimension     |        1 |
| TYPE_OF_TRANSFORMATION | Dimension     |        2 |
| FREQUENCY              | Dimension     |        3 |
| TIME_PERIOD            | TimeDimension |        4 |
| OBS_VALUE              | Measure       |       NA |

### Get codelists for dimensions we want to filter on

``` r
imf_get_codelists(dimension_ids = c("COUNTRY"), dataflow_id = "PPI") |>
  head() |>
  truncate_text(max_chars = 10) |>
  knitr::kable()
```

| dimension_id | code | name        | description | codelist_id | codelist_agency | codelist_version |
|:-------------|:-----|:------------|:------------|:------------|:----------------|:-----------------|
| COUNTRY      | AFG  | Afghanista… | NA          | CL_COUNTRY  | IMF             | 1.0+.0           |
| COUNTRY      | ALB  | Albania     | NA          | CL_COUNTRY  | IMF             | 1.0+.0           |
| COUNTRY      | DZA  | Algeria     | NA          | CL_COUNTRY  | IMF             | 1.0+.0           |
| COUNTRY      | ASM  | American S… | NA          | CL_COUNTRY  | IMF             | 1.0+.0           |
| COUNTRY      | AND  | Andorra, P… | NA          | CL_COUNTRY  | IMF             | 1.0+.0           |
| COUNTRY      | AGO  | Angola      | NA          | CL_COUNTRY  | IMF             | 1.0+.0           |

### Get data

``` r
imf_get(
  dataflow_id = "PPI",
  dimensions = list(FREQUENCY = c("A"), COUNTRY = c("USA", "CAN"))
) |>
  head()
```

    ## # A tibble: 6 × 6
    ##   COUNTRY INDICATOR TYPE_OF_TRANSFORMATION FREQUENCY TIME_PERIOD OBS_VALUE
    ##   <chr>   <chr>     <chr>                  <chr>     <chr>           <dbl>
    ## 1 CAN     PPI       IX                     A         1956             15.8
    ## 2 CAN     PPI       IX                     A         1957             16.1
    ## 3 CAN     PPI       IX                     A         1958             16.2
    ## 4 CAN     PPI       IX                     A         1959             16.4
    ## 5 CAN     PPI       IX                     A         1960             16.4
    ## 6 CAN     PPI       IX                     A         1961             16.4
