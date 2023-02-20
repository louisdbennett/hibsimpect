#' Generate an API token
#'
#' generate_token generates a token that can be used to get data from the Impect API
#'
#' @param username Impect login email
#' @param password Impect password
#' @import httr
#' @import dplyr
#' @import jsonlite

generate_token = function(username, password){
  login <- list(client_id = "api", grant_type = "password", username = username, password = password)

  token_request <- POST(url = "https://login.impect.com/auth/realms/production/protocol/openid-connect/token",body = login, encode = "form")

  token_body <- content(token_request, as = 'parsed')
  token_body$access_token
}
