
<!-- README.md is generated from README.Rmd. Please edit that file -->

# About

<!-- badges: start -->

<!-- badges: end -->

The **intensegRid** package is an API wrapper for [National Grid’s
Carbon Intensity API](https://carbonintensity.org.uk/). The API provides
information on national and regional carbon intensity - the amount of
carbon emitted per unit of energy consumed - for the UK.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("KKulma/intensegRid")
```

## Examples

Electricity is not made equal and it will have a smaller or greater
carbon footprint, (or carbon intensity), depending on its source, :

``` r
library(intensegRid)

# carbon intensity per electricity source
get_factors()
#>                     key value
#> 1               Biomass   120
#> 2                  Coal   937
#> 3         Dutch Imports   474
#> 4        French Imports    53
#> 5  Gas (Combined Cycle)   394
#> 6      Gas (Open Cycle)   651
#> 7                 Hydro     0
#> 8         Irish Imports   458
#> 9               Nuclear     0
#> 10                  Oil   935
#> 11                Other   300
#> 12       Pumped Storage     0
#> 13                Solar     0
#> 14                 Wind     0
```

### Carbon intensity for the whole UK

Current carbon intensity

``` r
## carbon intensity for the whole Britain for the current 1/2 hr period
get_british_ci()
#> # A tibble: 1 x 5
#>   from                to                  forecast actual index   
#>   <dttm>              <dttm>                 <int>  <int> <chr>   
#> 1 2020-06-03 14:00:00 2020-06-03 14:30:00      162    169 moderate
```

Current carbon intensity for specified dates

``` r
## function arguments
start <- "2019-04-01"
end <- "2019-04-07"

get_british_ci(start, end)
#> # A tibble: 336 x 5
#>    from                to                  forecast actual index   
#>    <dttm>              <dttm>                 <int>  <int> <chr>   
#>  1 2019-03-31 23:30:00 2019-04-01 00:00:00      203    158 low     
#>  2 2019-04-01 00:00:00 2019-04-01 00:30:00      196    161 moderate
#>  3 2019-04-01 00:30:00 2019-04-01 01:00:00      188    166 moderate
#>  4 2019-04-01 01:00:00 2019-04-01 01:30:00      183    171 moderate
#>  5 2019-04-01 01:30:00 2019-04-01 02:00:00      181    170 moderate
#>  6 2019-04-01 02:00:00 2019-04-01 02:30:00      182    168 moderate
#>  7 2019-04-01 02:30:00 2019-04-01 03:00:00      184    163 moderate
#>  8 2019-04-01 03:00:00 2019-04-01 03:30:00      184    162 moderate
#>  9 2019-04-01 03:30:00 2019-04-01 04:00:00      184    169 moderate
#> 10 2019-04-01 04:00:00 2019-04-01 04:30:00      184    183 moderate
#> # ... with 326 more rows
```

If you want to understand the exact composition of the UK-wide
electricity over time, you can use `get_mix()` function:

``` r
# electricity composition in the current 30 mins
get_mix()
#> # A tibble: 9 x 4
#>   fuel     perc from                to                 
#>   <chr>   <dbl> <dttm>              <dttm>             
#> 1 biomass  10.8 2020-06-03 14:00:00 2020-06-03 14:30:00
#> 2 coal      0   2020-06-03 14:00:00 2020-06-03 14:30:00
#> 3 imports   9.2 2020-06-03 14:00:00 2020-06-03 14:30:00
#> 4 gas      35.3 2020-06-03 14:00:00 2020-06-03 14:30:00
#> 5 nuclear  16.8 2020-06-03 14:00:00 2020-06-03 14:30:00
#> 6 other     0   2020-06-03 14:00:00 2020-06-03 14:30:00
#> 7 hydro     0.6 2020-06-03 14:00:00 2020-06-03 14:30:00
#> 8 solar     7.5 2020-06-03 14:00:00 2020-06-03 14:30:00
#> 9 wind     19.9 2020-06-03 14:00:00 2020-06-03 14:30:00
```

``` r
# electricity composition for the specified dates
get_mix(start, end)
#> # A tibble: 3,024 x 4
#>    from                to                  fuel     perc
#>    <dttm>              <dttm>              <chr>   <dbl>
#>  1 2019-03-31 23:30:00 2019-04-01 00:00:00 biomass   9.9
#>  2 2019-03-31 23:30:00 2019-04-01 00:00:00 coal      0  
#>  3 2019-03-31 23:30:00 2019-04-01 00:00:00 imports  10  
#>  4 2019-03-31 23:30:00 2019-04-01 00:00:00 gas      28.9
#>  5 2019-03-31 23:30:00 2019-04-01 00:00:00 nuclear  26.1
#>  6 2019-03-31 23:30:00 2019-04-01 00:00:00 other     0.3
#>  7 2019-03-31 23:30:00 2019-04-01 00:00:00 hydro     1.3
#>  8 2019-03-31 23:30:00 2019-04-01 00:00:00 solar     0  
#>  9 2019-03-31 23:30:00 2019-04-01 00:00:00 wind     23.5
#> 10 2019-04-01 00:00:00 2019-04-01 00:30:00 biomass   9.7
#> # ... with 3,014 more rows
```

Finally, you can access summarised carbon intensity statistics for the
specified dates:

``` r
get_stats(start, end)
#> # A tibble: 1 x 6
#>   from                to                    max average   min index   
#>   <dttm>              <dttm>              <int>   <int> <int> <chr>   
#> 1 2019-04-01 00:00:00 2019-04-07 23:59:00   294     224   112 moderate
```

Additionally, you can add a `block` argument that will group the
statistics by specified-length blocks, for example a block length of 2
(hrs over a 24 hr period) will return 12 items with the average, max,
min for each 2 hr block.

``` r
get_stats(start, end, block = 2)
#> # A tibble: 84 x 6
#>    from                to                    max average   min index   
#>    <dttm>              <dttm>              <int>   <int> <int> <chr>   
#>  1 2019-04-01 00:00:00 2019-04-01 02:00:00   171     167   161 moderate
#>  2 2019-04-01 02:00:00 2019-04-01 04:00:00   169     166   162 moderate
#>  3 2019-04-01 04:00:00 2019-04-01 06:00:00   230     207   183 moderate
#>  4 2019-04-01 06:00:00 2019-04-01 08:00:00   240     237   232 moderate
#>  5 2019-04-01 08:00:00 2019-04-01 10:00:00   226     213   201 moderate
#>  6 2019-04-01 10:00:00 2019-04-01 12:00:00   196     192   187 moderate
#>  7 2019-04-01 12:00:00 2019-04-01 14:00:00   205     196   188 moderate
#>  8 2019-04-01 14:00:00 2019-04-01 16:00:00   241     225   209 moderate
#>  9 2019-04-01 16:00:00 2019-04-01 18:00:00   269     259   250 moderate
#> 10 2019-04-01 18:00:00 2019-04-01 20:00:00   279     275   271 high    
#> # ... with 74 more rows
```

### Carbon intensity per UK country

**intensegRid** package allows you to access carbon intensity data per
UK country, i.e. England, Scotland and Wales (Northern Ireland is not
included) with `get_national_ci()`:

``` r
# Current carbon intensity per UK country
get_national_ci()
#> # A tibble: 162 x 9
#>    from                to                  regionid dnoregion shortname fuel 
#>    <dttm>              <dttm>                 <int> <chr>     <chr>     <chr>
#>  1 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ biom~
#>  2 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ coal 
#>  3 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ impo~
#>  4 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ gas  
#>  5 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ nucl~
#>  6 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ other
#>  7 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ hydro
#>  8 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ solar
#>  9 2020-06-03 14:00:00 2020-06-03 14:30:00        1 Scottish~ North Sc~ wind 
#> 10 2020-06-03 14:00:00 2020-06-03 14:30:00        2 SP Distr~ South Sc~ biom~
#> # ... with 152 more rows, and 3 more variables: perc <dbl>, forecast <int>,
#> #   index <chr>
```

``` r
# Current carbon intensity for England 
# Function also accepts region values: "Scotland" and "Wales"
get_national_ci(region = "England")
#> # A tibble: 9 x 9
#>   regionid dnoregion shortname from                to                  fuel 
#>      <int> <chr>     <chr>     <dttm>              <dttm>              <chr>
#> 1       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 biom~
#> 2       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 coal 
#> 3       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 impo~
#> 4       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 gas  
#> 5       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 nucl~
#> 6       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 other
#> 7       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 hydro
#> 8       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 solar
#> 9       15 England   England   2020-06-03 14:00:00 2020-06-03 14:30:00 wind 
#> # ... with 3 more variables: perc <dbl>, forecast <int>, index <chr>
```

``` r
# Carbon intensity for all the UK countries for specified dates 
get_national_ci(start = start, end = end)
#> # A tibble: 54,432 x 9
#>    from                to                  regionid dnoregion shortname fuel 
#>    <dttm>              <dttm>                 <int> <chr>     <chr>     <chr>
#>  1 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ biom~
#>  2 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ coal 
#>  3 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ impo~
#>  4 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ gas  
#>  5 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ nucl~
#>  6 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ other
#>  7 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ hydro
#>  8 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ solar
#>  9 2019-03-31 23:30:00 2019-04-01 00:00:00        1 Scottish~ North Sc~ wind 
#> 10 2019-03-31 23:30:00 2019-04-01 00:00:00        2 SP Distr~ South Sc~ biom~
#> # ... with 54,422 more rows, and 3 more variables: perc <dbl>, forecast <int>,
#> #   index <chr>
```

### Carbon intensity in UK regions

The API allows you extract information for UK regions using
`get_regional_ci()` function, that accepts `region_id` as a required
argument. You can access a handy `region_id` lookup table as a package
dataset:

``` r
regions_lookup
#>    Region ID          Shortname
#> 1          1     North Scotland
#> 2          2     South Scotland
#> 3          3 North West England
#> 4          4 North East England
#> 5          5          Yorkshire
#> 6          6        North Wales
#> 7          7        South Wales
#> 8          8      West Midlands
#> 9          9      East Midlands
#> 10        10       East England
#> 11        11 South West England
#> 12        12      South England
#> 13        13             London
#> 14        14 South East England
#> 15        15            England
#> 16        16           Scotland
#> 17        17              Wales
```

For example, let’s access the current carbon intensity for London:

``` r
get_regional_ci(region_id = 13)
#> # A tibble: 9 x 9
#>   regionid dnoregion shortname from                to                  fuel 
#>      <int> <chr>     <chr>     <dttm>              <dttm>              <chr>
#> 1       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 biom~
#> 2       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 coal 
#> 3       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 impo~
#> 4       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 gas  
#> 5       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 nucl~
#> 6       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 other
#> 7       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 hydro
#> 8       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 solar
#> 9       13 UKPN Lon~ London    2020-06-03 14:00:00 2020-06-03 14:30:00 wind 
#> # ... with 3 more variables: perc <dbl>, forecast <int>, index <chr>
```

Similarly to other functions in the package, `get_regional_ci()` also
accepts `start` and `end` arguments:

``` r
get_regional_ci(region_id = 13, 
                start, 
                end)
#> # A tibble: 3,024 x 9
#>    dnoregion shortname region_id from                to                  fuel 
#>    <chr>     <chr>         <int> <dttm>              <dttm>              <chr>
#>  1 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 biom~
#>  2 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 coal 
#>  3 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 impo~
#>  4 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 gas  
#>  5 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 nucl~
#>  6 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 other
#>  7 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 hydro
#>  8 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 solar
#>  9 UKPN Lon~ London           13 2019-03-31 23:30:00 2019-04-01 00:00:00 wind 
#> 10 UKPN Lon~ London           13 2019-04-01 00:00:00 2019-04-01 00:30:00 biom~
#> # ... with 3,014 more rows, and 3 more variables: perc <dbl>, forecast <int>,
#> #   index <chr>
```

### Carbon intensity per postcode

Finally, the API allows you to access carbon intensity data per
postcode. However, it only accepts outward postcode, i.e. one or two
letters, followed by one or two digits. For example, the following code
will access the carbon intensity information for EN2 area for the
current 1/2 hr:

``` r
get_postcode_ci(postcode = "EN2")
#> # A tibble: 9 x 10
#>   regionid dnoregion shortname postcode from                to                 
#>      <int> <chr>     <chr>     <chr>    <dttm>              <dttm>             
#> 1        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 2        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 3        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 4        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 5        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 6        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 7        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 8        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> 9        9 UKPN East East Eng~ EN2      2020-06-03 14:00:00 2020-06-03 14:30:00
#> # ... with 4 more variables: fuel <chr>, perc <dbl>, forecast <int>,
#> #   index <chr>
```

As always, we can pass `start` and `end` arguments to the function to
extend the time window:

``` r
get_postcode_ci(postcode = 'EN2',
                start,
                end)
#> # A tibble: 3,024 x 9
#>    region shortname postcode from                to                  fuel   perc
#>     <int> <chr>     <chr>    <dttm>              <dttm>              <chr> <dbl>
#>  1     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 biom~   0  
#>  2     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 coal    0  
#>  3     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 impo~   3.3
#>  4     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 gas     8.7
#>  5     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 nucl~  42.1
#>  6     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 other   0  
#>  7     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 hydro   0  
#>  8     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 solar   0  
#>  9     10 East Eng~ EN2      2019-03-31 23:30:00 2019-04-01 00:00:00 wind   45.9
#> 10     10 East Eng~ EN2      2019-04-01 00:00:00 2019-04-01 00:30:00 biom~   0.2
#> # ... with 3,014 more rows, and 2 more variables: forecast <int>, index <chr>
```

## Limitations

In its current form, the package only accepts dates as `start` or `end`
inputs (as Dates or character string), but not timestamps. However you
can easily filter the output of **intensegRid** functions using
[dplyr](https://dplyr.tidyverse.org/) and
[lubridate](https://lubridate.tidyverse.org/) packages.

## Contribution

This is an open-source project and it welcomes your contribution\! Feel
free to use and test the package and if you find a bug, please, report
it as [an issue](https://github.com/KKulma/intensegRid/issues). You may
want to go even a step further and fix an issue you just raised\!

If you’re rather new to open source and git, [this
repo](https://github.com/firstcontributions/first-contributions/blob/master/README.md)
offers some easy to follow guidance on how to start. Thanks for your
time and efforts\!
