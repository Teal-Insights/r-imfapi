# Get dataflow definitions for aLL available IMF datasets

Retrieves and returns all available dataflow definitions from the SDMX
dataflow endpoint.

## Usage

``` r
imf_get_dataflows(progress = FALSE, max_tries = 10L, cache = TRUE)
```

## Arguments

- progress:

  Logical; whether to show progress.

- max_tries:

  Integer; maximum retry attempts.

- cache:

  Logical; whether to cache the request.

## Value

tibble::tibble( id = character(), \# e.g., "MFS_IR", "SPE", etc. name =
character(), \# English name description = character(), \# English
description version = character(), \# e.g., "8.0.1" structure =
character(), \# DSD reference last_updated = character() \# from
annotations )

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  imf_get_dataflows()
}
#> # A tibble: 222 × 6
#>    id                       name         description version agency last_updated
#>    <chr>                    <chr>        <chr>       <chr>   <chr>  <chr>       
#>  1 PI                       "Production… "The Produ… 2.0.0   IMF.S… 2025-03-28T…
#>  2 MFS_IR                   "Monetary a… "The Monet… 9.0.0   IMF.S… 2026-05-19T…
#>  3 CPI_WCA_2026_FEB_VINTAGE "Consumer P… "Consumer … 1.0.0   IMF.S… 2026-02-25T…
#>  4 MFS_CBS_2026_JAN_VINTAGE "Monetary a… "Monetary … 1.0.0   IMF.S… 2026-02-06T…
#>  5 FA                       "Fund Accou… "The Fund … 8.0.0   IMF.S… 2025-03-28T…
#>  6 CPI_WCA_2026_APR_VINTAGE "Consumer P… "Consumer … 1.0.0   IMF.S… 2026-04-27T…
#>  7 CFBL                     "Carbon Foo… "This data… 1.0.3   IMF.S… 2026-01-07T…
#>  8 WORLD                    "World Reve… "The IMF's… 3.0.1   IMF.F… 2026-02-18T…
#>  9 TAXFIT                   "Tax and Be… "TaxFit is… 3.0.1   IMF.F… 2026-03-16T…
#> 10 SDG                      "IMF Report… "This data… 2.0.1   IMF.S… 2025-08-28T…
#> # ℹ 212 more rows
# }
```
