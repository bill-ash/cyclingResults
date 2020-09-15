## JSON provides lat long data for building maps with leaflet
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(rvest)
library(httr)
library(jsonlite)
library(DBI)
library(RSQLite)
library(testthat)

testthat::test_that('Build functions for road-results...', {

  # Race results  -----------------------------------------------------------
  rr_url <- 'https://www.road-results.com/downloadrace.php?raceID=12598&json=1'
  race_results <- jsonlite::fromJSON(rr_url)

  attributes(race_results)

  expect_s3_class(race_results, 'data.frame')

  # Rider results -----------------------------------------------------------


  # Team results  -----------------------------------------------------------




  # All races  --------------------------------------------------------------
  # One time GET
  # Store by year as .Rds files
  if (FALSE) {

    all_races <- 'https://www.road-results.com/?n=results&sn=all'
    races_html <- xml2::read_html(all_races)

    race_ids <- races_html %>%
      rvest::html_nodes('a') %>%
      rvest::html_attr('href') %>%
      grep('/race/', ., value = TRUE) %>%
      stringr::str_remove_all(., '/race/')

    store_races <- vector('list', length(race_ids))

    con <- DBI::dbConnect(RSQLite::SQLite(), 'inst/data/road-results/all_races.sqlite')

    for (i in seq_along(race_ids)) {

      z <- jsonlite::fromJSON(paste0('https://www.road-results.com/downloadrace.php?raceID=', race_ids[[i]], '&json=1'))

      if (is.data.frame(z)) {
        z <- mutate(z, raceID = race_ids[[i]])
      } else {
        z <- mutate(as.data.frame(z), raceID = race_ids[[i]])
      }

      store_races[[i]] <- z

      DBI::dbWriteTable(con, 'rr_races', z, append = TRUE)

    }

    DBI::dbDisconnect(con)

    rr_races <- store_races %>%
      bind_rows()

    readr::write_csv(rr_races, 'inst/data/road-results/all_races.csv')

  }


  # All riders --------------------------------------------------------------


  # All teams ---------------------------------------------------------------




})
