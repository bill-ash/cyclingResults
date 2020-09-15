library(testthat)
library(rvest)
library(jsonlite)
library(dplyr)
library(stringr)
library(tidyr)

skip('Run once')

testthat::test_that('How to query USA cycling results...', {

  # Start by trying to retreive all permits?
  # Do all permitted events have results?

  base_url <- 'https://legacy.usacycling.org/results/browse.php?state=%s&race=&fyear=%i'

  for (state in state.abb) {
    for (year in 2020:2005) {
      print(sprintf(base_url, state, year))

      url_resp <- xml2::read_html(sprintf(base_url, state, year))

      # appear to use the permit id as the guid for results query
      permit_id <- url_resp %>%
        html_nodes('a') %>%
        html_attr('href') %>%
        grep('/results/', .,  value = TRUE)

      if (length(permit_id) == 0) next

      usa_table <- url_resp %>%
        html_table() %>%
        purrr::pluck(1) %>%
        as_tibble() %>%
        select(race_date = 2, event_name = 3, submit_date = 4) %>%
        slice(-(1:2)) %>%
        mutate(permit_id = permit_id,
               state = state)

      readr::write_csv(usa_table, 'inst/usa-cycling/races-permits.csv', append = TRUE)

      Sys.sleep(1)

    }
  }


})
