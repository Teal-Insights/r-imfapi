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
#> # A tibble: 72 × 6
#>    id        name                        description version agency last_updated
#>    <chr>     <chr>                       <chr>       <chr>   <chr>  <chr>       
#>  1 QGDP_WCA  Quarterly Gross Domestic P… "This data… 3.0.0   IMF.S… 2025-08-01T…
#>  2 SPE       Special Purpose Entities (… "Special P… 13.0.0  IMF.S… 2025-06-03T…
#>  3 WPCPER    Crypto-based Parallel Exch… "This data… 5.0.2   IMF.S… 2025-09-22T…
#>  4 MFS_IR    Monetary and Financial Sta… "The Monet… 8.0.1   IMF.S… 2025-08-12T…
#>  5 GFS_SSUC  GFS Statement of Sources a… "The Gover… 10.0.0  IMF.S… 2025-06-06T…
#>  6 GFS_COFOG GFS Government Expenditure… "The Gover… 11.0.0  IMF.S… 2025-06-06T…
#>  7 IIPCC     Currency Composition of th… "The Curre… 13.0.0  IMF.S… 2025-06-03T…
#>  8 WHDREO    Western Hemisphere Regiona… "The WHD R… 5.0.0   IMF.W… 2025-10-15T…
#>  9 FSIC      Financial Soundness Indica… "The Finan… 13.0.1  IMF.S… 2025-08-05T…
#> 10 FDI       Financial Development Inde… "The datas… 1.0.0   IMF.M… 2025-07-03T…
#> # ℹ 62 more rows
# }
```
