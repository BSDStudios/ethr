#' Block Transaction Data
#' 
#' Queries the blockchain and returns a data.frame of transactions for either a
#' given number of blocks or a specified block range of blocks.
#' 
#' @param n_blocks numeric, Number of blocks to extract back from the latest
#'   block.
#' @param start_block numeric, Starting block number for extraction.
#' @param end_block numeric, Ending block for extraction, inclusive.
#' @param rpc_address character, The address of the RPC API.
#' @return data.frame Table combining the block data and transaction data
#'   returned by eth_getBlockByNumber and the transaction table contained within
#'   it.
#' @export
#' 
#' @examples
#' getBlockTransactions(100)
#' getBlockTransactions(start_block = 951460, end_block = 951560)
getBlockTransactions <- function(n_blocks = NULL, start_block = NULL, 
                                 end_block = NULL, parallel = FALSE, rpc_address = "http://localhost:8545") {
  
  # TODO
  # improve data validation for selections
  # Check for correct combination of inputs, needs finalising.
  if (!is.null(start_block) & !is.null(end_block) & !is.null(n_blocks)) {
    stop("Provide either 'start' and 'end' OR n_blocks")}
  
  # Determine the starting and ending block numbers based on inputs.
  if(is.null(n_blocks)) {
    end <- end_block
    start <- start_block
  } else {
    end <- as.numeric(hexDec(eth_blockNumber()))
    start <- end - (n_blocks -1)
  }
  
  transactions <- rbind(plyr::ldply(
    .data = start:end,
    .progress = "text",
    .parallel = parallel,
    .fun = function(x) {
      block <- eth_getBlockByNumber(block_number = decHex(x), full_list = TRUE)
        block_data <- collateBlockData(block)
      
      if(length(block$transactions) > 0) {
        transaction_data <- collateTransactionData(block$transactions)
        result <- merge(block_data, transaction_data, by = "blNumber")
      } else {
        result <- block_data
      }
      
      return(result)
    }))
  
  return(transactions)
}



collateBlockData <- function(block) {
  
  block_data <- data.frame(
    blNumber = as.numeric(hexDec(block$number)),
    blTimestamp = as.POSIXct(as.numeric(hexDec(block$timestamp)), origin = "1970-01-01"),
    blTimeHash = block$timestamp,
    blGasUsed = as.numeric(hexDec(block$gasUsed)),
    blGasLimit = as.numeric(hexDec(block$gasLimit)),
    blHash = block$hash,
    blMiner = block$miner,
    blDifficulty = as.numeric(hexDec(block$difficulty)),
    blSizeBytes = as.numeric(hexDec(block$size)),
    blParent = block$parentHash,
    blReceiptsRoot = block$receiptsRoot,
    blStateRoot = block$stateRoot,
    blTransactionsRoot = block$transactionsRoot,
    blNumberOfUncles = length(block$uncles))
  
  return(block_data)
}

collateTransactionData <- function(transaction_block) {
  
  transactions <- lapply(transaction_block, function(bl) {
    ifelse(is.null(bl$to), bl$to <- NA, bl$to)
    as.data.frame(bl, stringsAsFactors = FALSE)
  })
  
  transaction_data <- do.call(rbind, transactions)
  transaction_data <- data.frame(
    blNumber = as.numeric(hexDec(transaction_data$blockNumber)),
    trValueEth = as.numeric(ethCon(hexDec(transaction_data$value), from = "we", to = "et")),
    trIndex = as.numeric(hexDec(transaction_data$transactionIndex)),
    trGasLimit = as.numeric(hexDec(transaction_data$gas)),
    trGasPriceSzabo = as.numeric(ethCon(hexDec(transaction_data$gasPrice), from = "we", to = "sz")),
    trHash = transaction_data$hash,
    trFrom = transaction_data$from,
    trTo = transaction_data$to,
    trNonce = transaction_data$nonce)
 
  return(transaction_data)
}

