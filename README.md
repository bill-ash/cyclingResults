
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cyclingResults

<!-- badges: start -->

<!-- badges: end -->

The goal of cyclingResults is to query some cycling results.

## Installation

``` r
#remotes::install_github('bill-ash/cyclingResults')
library(cyclingResults)
```

## Example

Compare rider participation by region over time.

``` r
library(ggplot2)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

road_results <- cyclingResults::get_races() 

road_results %>% 
  group_by(date, region, .drop = FALSE) %>% 
  mutate(date = lubridate::floor_date(date, 'year')) %>% 
  summarise(total = sum(racers)) %>% 
  filter(date > '2012-01-01') %>% 
  ggplot(aes(date, total, color = region)) + 
  geom_line() + 
  scale_y_continuous(labels = scales::comma_format()) +
  labs(title = 'Rider participation by region by year.', 
       subtitle = 'January 2012 thru September 2020', 
       caption = 'Source: https://road-results.com',
       x = 'Year', y = 'Total rider participation') + 
  facet_wrap(~region, ) + 
  theme(legend.position = 'none')
#> `summarise()` regrouping output by 'date' (override with `.groups` argument)
```

<img src="man/figures/README-road_results plot-1.png" width="100%" />
