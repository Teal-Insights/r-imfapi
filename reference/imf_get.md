# Retrieve data from an IMF dataset

Fetches observations for a given `dataflow_id` and `resource_id` from
the IMF SDMX 3.0 Data API. The request key is constructed from the
dataset's datastructure (DSD) using the positional order of dimensions.
Time filtering is applied via query parameters.

## Usage

``` r
imf_get(
  dataflow_id,
  dimensions = list(),
  start_period = NULL,
  end_period = NULL,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE
)
```

## Arguments

- dataflow_id:

  Character scalar. The dataflow to query (e.g., "GFS").

- dimensions:

  Named list mapping dimension IDs to character vectors of codes to
  include. Omitted dimensions are wildcarded in the key. Each dimension
  position in the DSD corresponds to one dot-separated slot in the key;
  multiple codes per slot are joined by '+'.

- start_period:

  Optional character. Lower bound for time filtering (e.g., "2000",
  "2000-Q1", "2000-01").

- end_period:

  Optional character. Upper bound for time filtering, same format as
  `start_period`. The request always uses the SDMX 3.0 `dataflow`
  context under the hood and sets
  `dimensionAtObservation = "TIME_PERIOD"` to request a time-series
  view.

- progress:

  Logical; whether to show request progress.

- max_tries:

  Integer; maximum retry attempts for HTTP requests.

- cache:

  Logical; whether to enable caching for HTTP requests.

## Value

A tibble with one row per observation, including dimension columns, time
period, value column(s), and any requested attributes. Exact column
names follow the dataset's DSD and may vary by `dataflow_id`.

## Details

By default, the request targets the `all` agencies scope for the data
path, assuming dataflow IDs are globally unique in practice. The
response layout uses a time-series context, and client code will shape
the parsed payload into a tidy tibble.

The request key is built by ordering dimensions by their DSD `position`
and filling each position with either a '+'-joined set of selected codes
or a blank for wildcard. Time filtering is applied via `start_period`
and `end_period` query parameters rather than encoding time into the
key.

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  imf_get(
    dataflow_id = "FM",  # Fiscal Monitor
    dimensions = list(COUNTRY = c("USA", "CAN"))
  )
}
#> # A tibble: 552 × 5
#>    COUNTRY INDICATOR         FREQUENCY TIME_PERIOD OBS_VALUE
#>    <chr>   <chr>             <chr>     <chr>           <dbl>
#>  1 CAN     CAB_S13_POPGDP_PT A         1991           -7.61 
#>  2 CAN     CAB_S13_POPGDP_PT A         1992           -8.07 
#>  3 CAN     CAB_S13_POPGDP_PT A         1993           -8.05 
#>  4 CAN     CAB_S13_POPGDP_PT A         1994           -7.08 
#>  5 CAN     CAB_S13_POPGDP_PT A         1995           -5.58 
#>  6 CAN     CAB_S13_POPGDP_PT A         1996           -2.44 
#>  7 CAN     CAB_S13_POPGDP_PT A         1997            0.315
#>  8 CAN     CAB_S13_POPGDP_PT A         1998            0.346
#>  9 CAN     CAB_S13_POPGDP_PT A         1999            1.29 
#> 10 CAN     CAB_S13_POPGDP_PT A         2000            1.70 
#> # ℹ 542 more rows
# }
```
