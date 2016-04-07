#' getTransactionInTimePeriod
#'
#' @description Takes the start and end date and time, finds the blocks closest to those 
#' time and date. Then finds the transaction in that block range.
#'
#' @param start_date format "yyyy-mm-dd hh:mm:ss TZ" where TZ = time zone. (default is GMT)
#' @param end_date format "yyyy-mm-dd hh:mm:ss TZ" where TZ = time zone
#' @param rpc_address 
#' @return vector containing the start and end block number of hex format.
#' @export
#'
#' @examples
#' getTransactionInTimePeriod("2016-03-20 00:00:01 GMT","2016-03-20 23:59:59 GMT")
getTransactionInTimePeriod <- function(start_date = NULL, end_date=NULL, 
                                        rpc_address = "http://localhost:8545"){
  #Decide where to begin
  start_unix <- as.numeric(as.POSIXct(start_date),origin="1970-01-01")
  start_time_hex <- decHex(start_unix)   
  earliest_time <- hexDec("0x55ba4224")
  end_unix <- as.numeric(as.POSIXct(end_date))
  end_time_hex <- decHex(end_unix)  
  current_time <- as.numeric(as.POSIXct(Sys.time(),origin="1970-01-01"))
  #check valid start and end dates/times are entered.
  if (is.null(start_date) | is.null(end_date)) {
    stop("Please provide a 'start_date' and 'end_date'" )}
  
  if(start_unix < as.numeric(earliest_time)){
    stop("Please provide a start date after '2015-07-30 16:26:28 BST'")
  }
  if(end_unix > current_time){
    stop("Please provide an end date before the current time")
  }
  if(end_unix < start_unix){
    stop("Please provide a later end date than the start date")
  }
  if(end_unix < as.numeric(earliest_time)){
    stop("Please provide a end date after '2015-07-30 16:26:28 BST'")
  }  
  
  

  wanted_time <- hexDec(start_time_hex)

  #binary search
  bls <- seq(1, as.numeric(hexDec(eth_blockNumber())),1)
  wanted <- wanted_time
  halved <- round(max(bls)/2)
  compare_time <- as.numeric(hexDec(eth_getBlockByNumber(decHex(halved), full_list=FALSE)$timestamp))
  while(length(bls) >2){
      if(wanted_time > compare_time){
          range <- bls[which(bls==halved):which(bls==max(bls))]
          halved <- round((max(range) - min(range))/2) + min(range)
          bls <- range
          compare_time <- as.numeric(hexDec(eth_getBlockByNumber(decHex(halved), full_list=FALSE)$timestamp))
      }else{
          range <- bls[which(bls==min(bls)):which(bls==halved)]
          halved <- round(max((range) - min(range))/2) + min(range)
          bls <- range
          compare_time <- as.numeric(hexDec(eth_getBlockByNumber(decHex(halved), full_list=FALSE)$timestamp))
      }   
  }

  start_b <- bls[1]

  #Decide where to begin
  wanted_time <- hexDec(end_time_hex)

    
  #binary search
  bls2 <- seq(1, as.numeric(hexDec(eth_blockNumber())),1)
  wanted <- wanted_time
  halved <- round(max(bls2)/2)
  compare_time <- as.numeric(hexDec(eth_getBlockByNumber(decHex(halved), full_list=FALSE)$timestamp))
  while(length(bls2) >2){
      if(wanted_time > compare_time){
          range <- bls2[which(bls2==halved):which(bls2==max(bls2))]
          halved <- round((max(range) - min(range))/2) + min(range)
          bls2 <- range
          compare_time <- as.numeric(hexDec(eth_getBlockByNumber(decHex(halved), full_list=FALSE)$timestamp))
      }else{
          range <- bls2[which(bls2==min(bls2)):which(bls2==halved)]
          halved <- round(max((range) - min(range))/2) + min(range)
          bls2 <- range
          compare_time <- as.numeric(hexDec(eth_getBlockByNumber(decHex(halved), full_list=FALSE)$timestamp))
      }   
  }
  
  end_b <- bls2[2]
  blocks <- c(start_b,end_b)
  
  return(blocks)
} 