
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

The `imfapi` package provides a four-step workflow for retrieving data
from the IMF’s SDMX API:

### Step 1: List available dataflows and select one

Start by listing all available IMF datasets (dataflows) to find the one
you need:

``` r
imf_get_dataflows() |>
  head() |>
  # Note: We use a custom helper function to truncate long strings in columns
  truncate_text(max_chars = 10) |>
  knitr::kable()
```

| id        | name        | description | version | agency  | last_updated |
|:----------|:------------|:------------|:--------|:--------|:-------------|
| CPI_WCA   | Consumer P… | This datas… | 2.0.1   | IMF.STA | 2025-09-23…  |
| MFS_NSRF  | Monetary a… | The Moneta… | 1.0.3   | IMF.STA | 2025-08-12…  |
| GFS_BS    | GFS Balanc… | The Govern… | 12.0.0  | IMF.STA | 2025-06-06…  |
| ANEA      | National E… | This datas… | 6.0.1   | IMF.STA | 2025-03-28…  |
| GFS_COFOG | GFS Govern… | The Govern… | 11.0.0  | IMF.STA | 2025-06-06…  |
| BOP       | Balance of… | The Balanc… | 21.0.0  | IMF.STA | 2025-06-03…  |

Choose a dataflow based on its `id`, `name`, and `description`. In this
example, we’ll use the “PPI” (Producer Price Index) dataflow.

### Step 2: Get the dimensions for filtering

Each dataflow has a datastructure that defines which dimensions you can
filter on. Use `imf_get_datastructure()` to see what dimensions are
available:

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

The `dimension_id` column shows the filter dimensions you can use (e.g.,
`COUNTRY`, `FREQUENCY`). Set `include_time = TRUE` to see time
dimensions and `include_measures = TRUE` to see measure dimensions.

### Step 3: Fetch codelists for dimensions you want to filter on

For any dimension you want to filter, retrieve its codelist to see the
valid codes you can use:

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

The `code` column shows the values you’ll use in your filters (e.g.,
“USA”, “CAN”). The `name` column provides human-readable labels. You can
request codelists for multiple dimensions at once by passing a vector of
dimension IDs.

### Step 4: Request data with your filters

Finally, use `imf_get()` to fetch the actual data. Pass a named list of
dimension filters where each name is a `dimension_id` and each value is
a character vector of codes:

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

You can also use `start_period` and `end_period` arguments to filter by
time (e.g., `start_period = "2015"`, `end_period = "2020"`). If you omit
a dimension from the `dimensions` list, all values for that dimension
will be included.
