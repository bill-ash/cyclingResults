# compress results gathered from 2006-sept 2020
# moved to local < 1gb
# compress <- read.csv('inst/data/road-results/all_races.csv')

race_table = cyclingResults::get_races()

compress_region <- compress[, nchar(names(compress)) > 3] %>%
  dplyr::relocate(raceID, .after = RaceName) %>%
  mutate(raceID = as.character(raceID)) %>%
  left_join(race_table[,c('region', 'race_id')], c('raceID' = 'race_id')) %>%
  janitor::clean_names()


saveRDS(compress_region, 'inst/data/road-results/all-races.Rds')
