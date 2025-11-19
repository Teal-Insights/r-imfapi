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
if (curl::has_internet()) {
  imf_get_dataflows()
}
#> # A tibble: 71 × 6
#>    id                  name              description version agency last_updated
#>    <chr>               <chr>             <chr>       <chr>   <chr>  <chr>       
#>  1 GDD                 Global Debt Data… "The Globa… 2.0.0   IMF.F… 2025-04-16T…
#>  2 ITG_WCA             International Tr… "The datas… 2.0.4   IMF.S… 2025-04-15T…
#>  3 SRD                 Structural Refor… "The SRD c… 1.0.0   IMF.R… 2025-04-30T…
#>  4 CTOT                Commodity Terms … "CTOT is a… 5.0.1   IMF.R… 2025-11-14T…
#>  5 PPI                 Producer Price I… "Producer … 3.0.0   IMF.S… 2025-03-28T…
#>  6 EER                 Effective Exchan… "The Effec… 6.0.0   IMF.S… 2025-03-28T…
#>  7 PSBS                Public Sector Ba… "The Publi… 2.0.0   IMF.F… 2025-04-23T…
#>  8 MFS_OFC             Monetary and Fin… "The Monet… 6.0.1   IMF.S… 2025-08-12T…
#>  9 EQ                  Export Quality (… "This data… 2.0.0   IMF.R… 2025-03-29T…
#> 10 ISORA_2016_DATA_PUB ISORA 2016 Data   "ISORA dat… 2.0.0   ISORA  2025-06-19T…
#> # ℹ 61 more rows
```
