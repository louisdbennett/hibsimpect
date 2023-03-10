#' Get minutes played by all players in a vector of matches
#'
#' get_mins_from_matches returns a df with all minutes played in a vector of match IDs, which can be generated with get_matches
#'
#' @param token API token generated by get_token
#' @param matchids Vector of match IDs

get_mins_from_matches = function(token, matchID){
  t = 0
  # get KpiNames
  kpiList <- content(GET(url = paste("https://api.impect.com/v4/customerapi/kpis"), add_headers(Authorization = paste("Bearer", token, sep = " "))))

  kpiNames <- c(0:1500)
  for (i in 1:length(kpiList$data)) {
    kpiNames[[kpiList$data[[i]]$kpiId+1]] <- kpiList$data[[i]]$kpiName
  }

  cl <- makeCluster(detectCores())
  registerDoParallel(cl)

  start = Sys.time()
  # loop for each match input
  minsPlayed <- foreach(
    i = matchids,
    .packages = c("foreach", "dplyr", "httr", "jsonlite"),
    .combine = bind_rows,
    .multicombine = T,
    .errorhandling = 'remove',
    .export = c("get_mins")
  ) %dopar% {
    get_mins(token, i)
  }
  stopCluster(cl)
  print(Sys.time() - start)

  minsPlayed
}
