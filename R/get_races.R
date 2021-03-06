#' Get all races
#'
#' Returns a tibble of all race results from \url{road-results.com}.
#'
#' @return Returns a tibble of race results
#' @export
#'
#' @examples \dontrun{
#'
#'  get_races()
#'
#'  }
get_races <- function() {

  all_races <- 'https://www.road-results.com/?n=results&sn=all'

  race_resp <- xml2::read_html(all_races)

  race_ids <- race_resp %>%
    rvest::html_nodes('a') %>%
    rvest::html_attr('href') %>%
    grep('/race/', ., value = TRUE) %>%
    stringr::str_remove_all(., '/race/')


  race_table <- race_resp %>%
    rvest:::html_table() %>%
    dplyr::bind_rows() %>%
    dplyr::filter(!is.na(`Race Name`)) %>%
    dplyr::mutate(Date = as.Date.character(Date, '%b %d %Y'),
                  race_id = race_ids
    ) %>%
    dplyr::select(race_name = `Race Name`,
                  race_id,
                  date = Date,
                  region = Region,
                  racers = Racers) %>%
    dplyr::as_tibble()

  return(race_table)

}


#' Load raw results
#'
#' Load raw results from all events
#'
#' @return Returns a tibble of race results
#' @export
raw_results <- function() {

  dplyr::as_tibble(readRDS(system.file('road-results', 'all-races.Rds',
                      package = 'cyclingResults', mustWork = TRUE)))

}


#' Load USA cycling permits
#'
#' Load usa cycling permits from the events by state page.
#'
#' @return Returns a tibble of permits
#' @export
usa_permits <- function() {

  dplyr::as_tibble(readRDS(system.file('usa-cycling', 'race-permits.Rds',
                      package = 'cyclingResults', mustWork = TRUE)))

}
