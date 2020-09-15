library(tidyverse)

usa_permits <- read_csv('../data/races-permits.csv',
         col_names = c('race_date', 'event_name', 'submit_date', 'permit_id', 'state')) %>%
  mutate(race_date = as.Date(race_date, '%m/%d/%Y'),
         submit_date = as.Date(submit_date, '%m/%d/%Y'))


saveRDS(usa_permits, 'inst/usa-cycling/race-permits.Rds')
