
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cyclingResults

<!-- badges: start -->

<!-- badges: end -->

Analyze cycling results from [road results](https://road-results.com)
and [USA cycling](https://usacycling.org/).

## Installation

``` r
remotes::install_github('bill-ash/cyclingResults')
library(cyclingResults)
```

## Example

Compare rider participation by region over time.

``` r
library(dplyr)
library(ggplot2)

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
```

<img src="man/figures/README-region_plot-1.png" width="100%" />

Explore rider retention over time. Load all race results from 2008 to
2020. `raw_results()` loads a .Rds file of all rider results scraped
from [road results](https://road-results.com).

``` r
library(cyclingResults)
library(tidyverse)

races_raw <- raw_results() %>% 
  mutate(license = readr::parse_number(license)) %>% 
  filter(!is.na(license), 
         nchar(license) > 4 & nchar(license) < 7,
         !license %in% c(91005, 999999))

races_raw %>%
  select(license, date) %>% 
  group_by(license, date = lubridate::floor_date(date, 'year')) %>% 
  count(date, license, sort = TRUE) %>% 
  ungroup() %>% 
  group_by(license) %>%
  # cohort is defined as the earliest date a license appears in the data
  mutate(cohort = min(date)) %>% 
  ungroup() %>% 
  group_by(cohort, date) %>% 
  # total participation by cohort, by year
  summarise(total = sum(n), 
            cohort = as.factor(lubridate::year(cohort))) %>% 
  filter(cohort != 2020) %>% 
  ggplot(aes(date, total, color = cohort)) + 
  geom_line() + 
  scale_y_continuous(labels = scales::comma_format()) + 
  labs(title = 'Rider retention in free fall since 2013.',
       x = 'Year', y = 'Rider participation by "start year"',
       caption = 'Source: https://road-results.com') + 
  facet_wrap(~cohort) + 
  theme(legend.position = 'none')
```

<img src="man/figures/README-cohort-plot-1.png" width="100%" />

Analyze permit data from USA cycling with `usa_permits()`.

``` r
library(cyclingResults)
library(dplyr)
library(ggplot2)

usa_cycling_permits <- cyclingResults::usa_permits() 

usa_cycling_permits %>% 
  group_by(year = as.factor(lubridate::year(race_date)), .drop = FALSE) %>% 
  summarise(total = n()) %>% 
  ggplot(aes(year, total)) + 
  geom_col() + 
  scale_y_continuous(labels = scales::comma_format()) +
  coord_flip() + 
  labs(title = 'USA cycling events with reported results by year.',
       subtitle = 'All disciplines',
       caption = 'Source: https://usacycling.org',
       x = '', y = 'Count of events')
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

This package is still in development.
