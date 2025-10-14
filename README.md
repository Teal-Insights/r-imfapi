
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

| id       | name        | description | version | agency  | last_updated |
|:---------|:------------|:------------|:--------|:--------|:-------------|
| PPI      | Producer P… | Producer P… | 3.0.0   | IMF.STA | 2025-03-28…  |
| GFS_SFCP | GFS Stocks… | The Govern… | 10.0.0  | IMF.STA | 2025-06-06…  |
| MFS_OFC  | Monetary a… | The Moneta… | 6.0.1   | IMF.STA | 2025-08-12…  |
| PSBS     | Public Sec… | The Public… | 2.0.0   | IMF.FAD | 2025-04-23…  |
| EQ       | Export Qua… | This datas… | 2.0.0   | IMF.RES | 2025-03-29…  |
| WEO      | World Econ… | The World … | 6.0.0   | IMF.RES | 2025-03-28…  |

### Get datastructure dimensions

``` r
imf_get_datastructure(
  "GFS_SOO", include_time = TRUE, include_measures = TRUE
) |>
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
imf_get_codelists(c("COUNTRY"), dataflow_id = "GFS_SOO") |>
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
  dataflow_id = "GFS_SOO",
  resource_id = "GFS_SOO",
  dimensions = list(COUNTRY = c("USA", "CAN")),
  start_period = "2019",
  end_period = "2020"
) |>
  head() |>
  knitr::kable()
```

<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

| x       |
|:--------|
| Replace |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   4 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   5 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   6 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   7 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   8 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   4 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   9 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  10 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  11 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   4 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   5 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  12 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  13 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   6 |

</td>
<td>

|   x |
|----:|
|  14 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  15 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  16 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   7 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   8 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  17 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   4 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  18 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   9 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  19 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  20 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  21 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  10 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   4 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  13 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  11 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  22 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  23 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  24 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  25 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  26 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  12 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  27 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  28 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  29 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   9 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  30 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  31 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  13 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  14 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  32 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  15 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  33 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  34 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  35 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  36 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  37 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  38 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  39 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  40 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  16 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   9 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  41 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  42 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  43 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  14 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  44 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  17 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  45 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  18 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   5 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  19 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  20 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  46 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  47 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  16 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  48 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  32 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  16 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  48 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  11 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  22 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  49 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  21 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  13 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  22 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  50 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   6 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  23 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  51 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  24 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  52 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  53 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  54 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  55 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  56 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  57 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  58 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  59 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  60 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  61 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  37 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  62 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  63 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  64 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  25 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  65 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  26 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  27 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  49 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  66 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  67 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  68 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  69 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  12 |

</td>
<td>

|   x |
|----:|
|  14 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  28 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  70 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  16 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  29 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  71 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  72 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  73 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  74 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  14 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  75 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  76 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  77 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  30 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  78 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  49 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  13 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  31 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  32 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  79 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  33 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  80 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  81 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  82 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  34 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  83 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  84 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  35 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  36 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  85 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  86 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   5 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  37 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  12 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  87 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  88 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  83 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  89 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  90 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   5 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   5 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  91 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  92 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|   6 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  14 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  93 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  94 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  95 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  96 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  38 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  97 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  98 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  99 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  39 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 100 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 101 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 102 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 103 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 104 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  22 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 105 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 106 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 107 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  30 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  16 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  49 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 108 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   5 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  40 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  91 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
|  22 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 109 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  41 |

</td>
<td>

|   x |
|----:|
|  14 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  42 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 110 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 111 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 112 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 113 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 114 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  43 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  14 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  44 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 115 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  16 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  14 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 116 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 117 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|  45 |

</td>
<td>

|   x |
|----:|
|  14 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   2 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 118 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 119 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
<td>

|   x |
|----:|
| 120 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

|   x |
|----:|
|   0 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                                                                            |
|:-----------------------------------------------------------------------------|
| <urn:sdmx:org.sdmx.infomodel.datastructure.Dataflow=IMF.STA:GFS_SOO(12.0.0>) |

</td>
<td>

| x        |
|:---------|
| Dataflow |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                                                                                 |
|:----------------------------------------------------------------------------------|
| <urn:sdmx:org.sdmx.infomodel.datastructure.DataStructure=IMF.STA:DSD_GFS(17.0.0>) |

</td>
<td>

| x                       |
|:------------------------|
| DataStructureDefinition |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| COUNTRY |

</td>
<td>

|   x |
|----:|
|   0 |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| SECTOR |

</td>
<td>

|   x |
|----:|
|   1 |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| GFS_GRP |

</td>
<td>

|   x |
|----:|
|   2 |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
<td>

|   x |
|----:|
|   3 |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F4_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G111_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F2_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F8_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1153_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G24_NRES_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G2812_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G13_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G26C_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G26K_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G24_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1213_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F8_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F2_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1141_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F3_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G112_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| N212G_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F6_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G113IM_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G25_S1_Z_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x              |
|:---------------|
| GDD4D1_SFD_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1416_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G14_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| FAADJ_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| N113N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| GPB_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| G24_S1W_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G13FG_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F1_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| OVTRANSK_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G2811_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1152_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| N13A_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G24_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G25_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F4_G33_DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| F12_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G26_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1212_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G145_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F3_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G122_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1223_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| FA_FD_A_SP |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G281MK_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G1_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G281MC_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F4_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F1_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2M_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1415_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                     |
|:----------------------|
| GDD4D1T_G33_L_T_MV_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F7GFS_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G13K_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F3_G33_DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| N211N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1151_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G22_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                 |
|:------------------|
| G32OTC_A_T_CAB_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1113_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G13C_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1211_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G13KFG_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F2_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G26CIO_IO_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F5_G33_DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F1_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| GGOB_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G273_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G212_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F3_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                |
|:-----------------|
| F7GFS_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1222_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| F66_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G114_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| N11N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F6_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F8_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x            |
|:-------------|
| NDOTI_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| F61_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1135_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1112_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F5_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G23_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| G13K_IO_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F5_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G23_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x              |
|:---------------|
| F12_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x               |
|:----------------|
| G26_S13111_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x            |
|:-------------|
| G1411_S13U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| N2N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G25_S1K1_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| N12N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| GNLB_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G13_IO_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| NLG_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| SFDCNWCS_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| NYNA_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G31_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1146_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| GGB_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G211_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G113_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1452_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1221_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G11451_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1413_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G26CFG_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| G13C_IO_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G11_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G283_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G2831_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x              |
|:---------------|
| DMV_G33_L_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1111_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| N13N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F4_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x              |
|:---------------|
| NNADISP_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G1411_S1W_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G125U_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G142_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| OVTRANS_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G28_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| FA_SFD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| F6N_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F4_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G271_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F5_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| N11PN_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G1414I_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F3_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1145_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| OVTRANC_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G11413_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                |
|:-----------------|
| F7GFS_G33_DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G116_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1451_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G11452_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| TL_FC_L_SP |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1412_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x            |
|:-------------|
| G1411_NRES_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| G25_S1KP_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| F63_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                     |
|:----------------------|
| GDD4D2T_G33_L_T_MV_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G21_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F8_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| N13D_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G2815_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1156_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1133_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| N21KN_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| L_SP |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| NFWSFD_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G26KIO_IO_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| NNFAG_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| NYNBS_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1424_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G141_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F6_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| N114N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| FA_A_SP |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G272_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1144_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x              |
|:---------------|
| NFWSFD_NETAL_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G115_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G11414_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F6_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F6_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G3_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G2_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G13_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                |
|:-----------------|
| F7GFS_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G212I_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1132_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G281_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G212A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| F62_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G2814_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1155_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1422_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                     |
|:----------------------|
| GDD4D3T_G33_L_T_MV_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| GNOB_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G26FGR_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1423_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G121_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F2_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| G3M2_N_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F4_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G26_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G26KFG_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G26FG_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1143_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| TL_DC_L_SP |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F5_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| DD_A_SP |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1411_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G11411_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F6_G33_DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| N11D_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G3_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G26_IO_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G12_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| NFA_SFD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| N2KN_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G282_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1154_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1131_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G2813_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G28313_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| MIN2N_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F7GFS_G33_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| N11A_A_T_MI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1421_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F5_G33_FC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                |
|:-----------------|
| F7GFS_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F3_G32_DD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F8_G32_FD_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G143_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G27_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| L_SFD_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F8_G33_DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| G1142_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| F2_G33_DC_L_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x          |
|:-----------|
| F2_G32_A_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2G_T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| G11412_T |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                      |
|:-----------------------|
| TYPE_OF_TRANSFORMATION |

</td>
<td>

|   x |
|----:|
|   4 |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| POGDP_PT |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| XDC |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| FREQUENCY |

</td>
<td>

|   x |
|----:|
|   5 |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| FREQ |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| TIME_PERIOD |

</td>
<td>

|   x |
|----:|
|   6 |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| OBS_VALUE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| INSTR_ASSET |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F4  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F2  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F8  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F3  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| N212G |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F6  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| GDD4D1 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| FAADJ |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| N113N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F1  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N13A |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F12 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| FA  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| GDD4D1T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| F7GFS |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| N211N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F5  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F66 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N11N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| NDOTI |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F61 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| N2N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N12N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| NLG |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| NYNA |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| DMV |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N13N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| NNADISP |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F6N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| N11PN |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| TL  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F63 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| GDD4D2T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N13D |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| N21KN |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| NNFAG |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| NYNBS |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| N114N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| F62 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| GDD4D3T |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N11D |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| NFA |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N2KN |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| MIN2N |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| N11A |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| L   |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| GFS_STO |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G33 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G111 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G32 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1153 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G24 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2812 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G13 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G26C |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G26K |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1213 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1141 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G112 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G113IM |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G25 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| SFD |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1416 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G14 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| GPB |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G13FG |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| OVTRANSK |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2811 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1152 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G26 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1212 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G145 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G122 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1223 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G281MK |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G1  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G281MC |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G2M |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1415 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G13K |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1151 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G22 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G32OTC |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1113 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G13C |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1211 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G13KFG |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G26CIO |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| GGOB |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G273 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G212 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1222 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G114 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1135 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1112 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G23 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1411 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| GNLB |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| SFDCNWCS |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G31 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1146 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| GGB |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G211 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G113 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1452 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1221 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G11451 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1413 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G26CFG |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G11 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G283 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2831 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1111 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G125U |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G142 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| OVTRANS |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G28 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G271 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G1414I |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1145 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| OVTRANC |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G11413 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G116 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1451 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G11452 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1412 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G21 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2815 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1156 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1133 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| NFWSFD |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G26KIO |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1424 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G141 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G272 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1144 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G115 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G11414 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G3  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G2  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G212I |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1132 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G281 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G212A |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2814 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1155 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1422 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| GNOB |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G26FGR |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1423 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G121 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G3M2 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G26KFG |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G26FG |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1143 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G11411 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G12 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G282 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1154 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1131 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G2813 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G28313 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1421 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| G143 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G27 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| G1142 |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| G2G |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| G11412 |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| COFOG |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| CURRENCY |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| INT_TTC |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                  |
|:-------------------|
| COUNTERPART_SECTOR |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| GFS_DF |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| FC  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| DD  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| FD  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| DC  |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                |
|:-----------------|
| ACCOUNTING_ENTRY |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| L   |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| A   |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| NETAL |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| N   |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                |
|:-----------------|
| FLOW_STOCK_ENTRY |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| T   |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| SP  |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x           |
|:------------|
| FI_MATURITY |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| GFS_RB |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| MV  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| CAB |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                    |
|:---------------------|
| STATISTICAL_MEASURES |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x             |
|:--------------|
| GFS_COMPONENT |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| MI  |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x              |
|:---------------|
| TRANSFORMATION |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                      |
|:-----------------------|
| TYPE_OF_TRANSFORMATION |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| POGDP |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x        |
|:---------|
| ACCOUNTS |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| SOO |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| SFCP |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x    |
|:-----|
| UNIT |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                      |
|:-----------------------|
| TYPE_OF_TRANSFORMATION |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| PT  |

</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x   |
|:----|
| XDC |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x     |
|:------|
| SCALE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| COUNTRY |

</td>
<td>

| x       |
|:--------|
| GFS_GRP |

</td>
<td>

| x      |
|:-------|
| SECTOR |

</td>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
<td>

| x                      |
|:-----------------------|
| TYPE_OF_TRANSFORMATION |

</td>
<td>

| x         |
|:----------|
| FREQUENCY |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                  |
|:-------------------|
| DECIMALS_DISPLAYED |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| COUNTRY |

</td>
<td>

| x       |
|:--------|
| GFS_GRP |

</td>
<td>

| x      |
|:-------|
| SECTOR |

</td>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
<td>

| x                      |
|:-----------------------|
| TYPE_OF_TRANSFORMATION |

</td>
<td>

| x         |
|:----------|
| FREQUENCY |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| OVERLAP |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x       |
|:--------|
| COUNTRY |

</td>
<td>

| x       |
|:--------|
| GFS_GRP |

</td>
<td>

| x      |
|:-------|
| SECTOR |

</td>
<td>

| x         |
|:----------|
| INDICATOR |

</td>
<td>

| x                      |
|:-----------------------|
| TYPE_OF_TRANSFORMATION |

</td>
<td>

| x         |
|:----------|
| FREQUENCY |

</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| PRECISION |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x               |
|:----------------|
| DERIVATION_TYPE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x      |
|:-------|
| STATUS |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x              |
|:---------------|
| NATURE_OF_DATA |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                                |
|:---------------------------------|
| BASES_OF_RECORDING_CASH_NON_CASH |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x                            |
|:-----------------------------|
| BASES_OF_RECORDING_GROSS_NET |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>

| x         |
|:----------|
| VALUATION |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
<td>

| x     |
|:------|
| FALSE |

</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
<td>
<table class="kable_wrapper">
<tbody>
<tr>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
