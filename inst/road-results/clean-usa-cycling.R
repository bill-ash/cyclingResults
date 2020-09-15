library(tidyverse)


usa_races <- read_csv('../races-permits.csv') %>%
  mutate(race_date = as.Date(race_date, '%m/%d/%y'),
         submit_date = as.Date(submit_date, '%m/%d/%y'))


saveRDS(usa_races, 'inst/usa-cycling/race-permits.Rds')
