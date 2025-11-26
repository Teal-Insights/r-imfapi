# Retrieve codes for one or more dimensions as a tidy tibble

Returns a tibble mapping dimensions to their codes and labels by
fetching the corresponding codelists. By convention, codelist IDs are
assumed to be `CL_{dimension_id}` for first-pass coverage.

## Usage

``` r
imf_get_codelists(
  dimension_ids,
  dataflow_id,
  progress = FALSE,
  max_tries = 10L,
  cache = TRUE
)
```

## Arguments

- dimension_ids:

  Character vector of dimension IDs (e.g., "COUNTRY").

- dataflow_id:

  Character scalar. The dataflow whose datastructure is used to resolve
  each dimension's codelist via its concept scheme reference.

- progress:

  Logical; whether to show progress.

- max_tries:

  Integer; maximum retry attempts.

- cache:

  Logical; whether to cache requests.

## Value

tibble::tibble( dimension_id = character(), code = character(), name =
character(), description = character(), codelist_id = character(),
codelist_agency = character(), codelist_version = character() )

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  imf_get_codelists(
    c("FREQUENCY", "TIME_PERIOD"),
    dataflow_id = "FM"  # Fiscal Monitor
  )
}
#> # A tibble: 6 × 7
#>   dimension_id code  name                description codelist_id codelist_agency
#>   <chr>        <chr> <chr>               <chr>       <chr>       <chr>          
#> 1 FREQUENCY    A     Annual              To be used… CL_FREQ     IMF            
#> 2 FREQUENCY    D     Daily               To be used… CL_FREQ     IMF            
#> 3 FREQUENCY    M     Monthly             To be used… CL_FREQ     IMF            
#> 4 FREQUENCY    Q     Quarterly           To be used… CL_FREQ     IMF            
#> 5 FREQUENCY    S     Half-yearly, semes… To be used… CL_FREQ     IMF            
#> 6 FREQUENCY    W     Weekly              To be used… CL_FREQ     IMF            
#> # ℹ 1 more variable: codelist_version <chr>
# }
```
