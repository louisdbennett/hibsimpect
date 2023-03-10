#' Generate match information
#'
#' get_match_details returns information about a single match details - including match_id, match_date, home + away teams and final score.
#'
#' @param token API token generated by get_token
#' @param matchID Impect match ID

get_match_details = function(token, matchID){
  test <- (GET(url = paste0("https://api.impect.com/v4/customerapi/matches/",matchID), add_headers(Authorization = paste("Bearer", token, sep = " "))))

  if (test$status_code == 200) {
    matchDetails <- content(test)
  } else {
    # loop in case of reaching the request limit
    Sys.sleep(1)
    t <- t+1
    matchDetails <- content(GET(url = paste0("https://api.impect.com/v4/customerapi/matches/",match_id), add_headers(Authorization = paste("Bearer", token, sep = " "))))
  }
  ifelse(is.null(matchDetails$data$date),
         match_date <- NA,
         match_date <- matchDetails$data$date)
  ifelse(is.null(matchDetails$data$dateTime),
         kick_off <- NA,
         kick_off <- matchDetails$data$dateTime)
  ifelse(is.null(matchDetails$data$squadHome$squadId),
         home_team_id <- NA,
         home_team_id <- matchDetails$data$squadHome$squadId)
  ifelse(is.null(matchDetails$data$squadHome$name),
         home_team <- NA,
         home_team <- matchDetails$data$squadHome$name)
  ifelse(is.null(matchDetails$data$squadAway$squadId),
         away_team_id <- NA,
         away_team_id <- matchDetails$data$squadAway$squadId)
  ifelse(is.null(matchDetails$data$squadAway$name),
         away_team <- NA,
         away_team <- matchDetails$data$squadAway$name)
  ifelse(is.null(matchDetails$data$competition$competitionIterationStepId),
         gameweek_id <- NA,
         gameweek_id <- matchDetails$data$competition$competitionIterationStepId)
  ifelse(is.null(matchDetails$data$competition$competitionIterationStepName),
         gameweek <- NA,
         gameweek <- matchDetails$data$competition$competitionIterationStepName)
  ifelse(is.null(matchDetails$data$competition$competitionId),
         comp_id <- NA,
         comp_id <- matchDetails$data$competition$competitionId)
  ifelse(is.null(matchDetails$data$competition$competition),
         competition <- NA,
         competition <- matchDetails$data$competition$competition)
  ifelse(is.null(matchDetails$data$competition$competitionIterationId),
         season_id <- NA,
         season_id <- matchDetails$data$competition$competitionIterationId)
  ifelse(is.null(matchDetails$data$competition$competitionIterationName),
         season <- NA,
         season <- matchDetails$data$competition$competitionIterationName)
  ifelse(is.null(matchDetails$data$squadHome$goals)|is.null(matchDetails$data$squadAway$goals),
         score <- NA,
         score <- paste0(matchDetails$data$squadHome$goals," - ",matchDetails$data$squadAway$goals))

  data.frame(matchID,match_date,kick_off,home_team_id,home_team,away_team_id,away_team,gameweek_id,gameweek,comp_id,competition,season_id,season,score)
}
