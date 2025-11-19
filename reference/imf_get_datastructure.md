# Retrieve the datastructure definition for an IMF dataflow.

Retrieve the datastructure definition for an IMF dataflow.

## Usage

``` r
imf_get_datastructure(
  dataflow_id,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE,
  include_time = FALSE,
  include_measures = FALSE
)
```

## Arguments

- dataflow_id:

  The ID of the dataflow to retrieve the datastructure for.

- progress:

  Logical; whether to show progress.

- max_tries:

  Integer; maximum retry attempts.

- cache:

  Logical; whether to cache the request.

- include_time:

  Logical; whether to include time dimensions.

- include_measures:

  Logical; whether to include measure dimensions.

## Value

tibble::tibble( dimension_id = character(), type = character(), position
= integer() )

## Examples

``` r
if (curl::has_internet()) {
  imf_get_datastructure("PSBS")
}
#> # A tibble: 6 × 3
#>   dimension_id type      position
#>   <chr>        <chr>        <int>
#> 1 COUNTRY      Dimension        0
#> 2 SECTOR       Dimension        1
#> 3 ACCOUNTS     Dimension        2
#> 4 INDICATOR    Dimension        3
#> 5 UNIT         Dimension        4
#> 6 FREQUENCY    Dimension        5
```
