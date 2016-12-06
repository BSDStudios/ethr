#' Block Headers
#'
#' @description Queries the blockchain and returns a data.frame of the block headers for either a given
#' number of blocks or a specified block range of blocks.
#'
#' @param n_blocks numeric, Number of blocks to extract back from the latest block. 
#' @param start_block numeric, Starting block number for extraction. 
#' @param end_block numeric, Ending block for extraction, inclusive. 
#' @param parallel boolean, invokes a parallelised plyr loop
#' @param rpc_address, The address of the RPC API.
#' 
#' To initialise parallel workers:
#' workers <-makeCluster(3)
#' doParallel::registerDoParallel(workers) 
#'
#' @return data.frame Block header data of requested blocks.
#' @export
#'
#' @examples
#' getBlockHeaders(100)
#' getBlockHeaders(start_block = 951460, end_block = 951560)
getBlockHeaders <- function(n_blocks = NULL, start_block = NULL, 
                                 end_block = NULL, parallel = FALSE, rpc_address = "http://localhost:8545") {

  
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
      return(block_data)
      }  ))
  
  return(transactions)
}