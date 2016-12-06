# These are all basic functions to connect to the geth/parity JSON RPC interface.
# They are designed to replicate the base functionality and facilitate
# pulling data into R and onto further helper functions. Where possible these mimic
# the behaviour of the functions that can be found here, [https://github.com/ethereum/wiki/wiki/JSON-RPC]


#' eth_coinbase
#'
#' Returns the client coinbase address.
#'
#' @param rpc_address The address of the RPC API.
#' @return 20 bytes - the current coinbase address.
#' @export
eth_coinbase <- function(rpc_address = "http://localhost:8545") {
  
  body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                      method = jsonlite::unbox("eth_coinbase"), 
                      params = I(NULL), 
                      id = jsonlite::unbox(64)))
  
  post_return <- httr::POST(url = rpc_address, 
                           httr::add_headers("Content-Type" = "application/json"),
                           body = body)
  
  acc_no <- httr::content(post_return, "parsed")$result
  
  return(acc_no)
}


#' eth_gasPrice
#'
#' Returns the current price per gas in wei.
#'
#' @param rpc_address The address of the RPC API.
#' @return hex value of the current gas price in wei.
#' @export
eth_gasPrice <- function(rpc_address = "http://localhost:8545") {
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                          method = jsonlite::unbox("eth_gasPrice"), 
                          params = I(NULL), 
                          id = jsonlite::unbox(73)))
  
  post_return <- httr::POST(url = rpc_address,
                            httr::add_headers("Content-Type" = "application/json"),
                            body = post_body)
  
  post_content <- httr::content(post_return, as = "parsed")
  
  gas_price <- post_content$result
  
  return(gas_price)
}


#' eth_accounts
#'
#' Returns a list of addresses owned by client.
#'
#' @param rpc_address The address of the RPC API.
#' @return 20 Bytes - addresses owned by the client.
#' @export
eth_accounts <- function(rpc_address = "http://localhost:8545") {
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_accounts"), 
                           params = I(NULL), 
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                            httr::add_headers("Content-Type" = "application/json"),
                            body = post_body)
  
  post_content <- httr::content(post_return, as = "parsed")
  
  accounts <- unlist(post_content$result)
  
  return(accounts)
}


#' eth_blockNumber
#'
#' Returns the number of most recent block.
#'
#' @param rpc_address The address of the RPC API.
#' @return hex value of the current block number the client is on.
#' @export
eth_blockNumber <- function(rpc_address = "http://localhost:8545") {
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_blockNumber"), 
                           params = I(NULL), 
                           id = jsonlite::unbox(83)))
  
  post_return <- httr::POST(url = rpc_address,
                            httr::add_headers("Content-Type" = "application/json"),
                            body = post_body)  
  
  post_content <- httr::content(post_return, as = "parsed")
  
  block_number <- post_content$result
  
  return(block_number)
}


#' eth_getBalance
#'
#' Returns the balance of the account of given address.
#'
#' @param address 20 Bytes - address to check for balance.
#' @param block_number hex value of block number, or the string "latest", "earliest" or "pending".
#' @param rpc_address The address of the RPC API.
#' @return hex value of the current balance in wei.
#' @export
eth_getBalance <- function(address, block_number, rpc_address = "http://localhost:8545") {

  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getBalance"), 
                           params = c(address, block_number), 
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                           httr::add_headers("Content-Type" = "application/json"),
                           body = post_body)
  
  balance <- httr::content(post_return, "parsed")$result
  
  return(balance)
}


#' eth_getStorageAt
#'
#' Returns the value from a storage position at a given address.
#'
#' @param address 20 Bytes - address of the storage.
#' @param position_number hex value of the position in the storage.
#' @param block_number hex value of block number, or the string "latest", "earliest" or "pending".
#' @param rpc_address The address of the RPC API.
#' @return the value at this storage position.
#' @export
eth_getStorageAt <- function(address, position_number, block_number, 
                             rpc_address = "http://localhost:8545") {
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getStorageAt"), 
                           params = c(address, position_number, block_number),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                               httr::add_headers("Content-Type" = "application/json"),
                               body = post_body)
  
  storage <-httr::content(post_return)$result
  
  return(storage)
}


#' eth_getTransactionCount
#'
#' Returns the number of transactions sent from an address - state at given block number.
#'
#' @param address 20 Bytes - address.
#' @param block_number hex value of block number, or the string "latest", "earliest" or "pending".
#' @param rpc_address The address of the RPC API.
#' @return hex of the number of transactions send from this address.
#' @export
eth_getTransactionCount <- function(address, block_number, rpc_address = "http://localhost:8545") {

  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getTransactionCount"), 
                           params = c(address, block_number),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                             httr::add_headers("Content-Type" = "application/json"),
                             body = post_body)
  
  trans_count <-httr::content(post_return)$result
  
  return(trans_count)
}


#' eth_getBlockTransactionCountByHash
#'
#' Returns the number of transactions in a block from a block matching the given block hash.
#'
#' @param block_hash 32 Bytes - hash of a block.
#' @param rpc_address The address of the RPC API.
#' @return hex value of the number of transactions in this block.
#' @export
eth_getBlockTransactionCountByHash <- function(block_hash, rpc_address = "http://localhost:8545") {

  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getBlockTransactionCountByHash"), 
                           params = c(block_hash),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                                httr::add_headers("Content-Type" = "application/json"),
                                body = post_body)
  
  block_transaction_count <- httr::content(post_return)$result
  
  return(block_transaction_count)
}


#' eth_getBlockTransactionCountByNumber
#'
#' Returns the number of transactions in a block from a block matching the given block number.
#'
#' @param block_number hex value of a block number, or the string "earliest", "latest" or "pending".
#' @param rpc_address The address of the RPC API.
#' @return QUANTITY - integer of the number of transactions in this block, hex format
#' @export
eth_getBlockTransactionCountByNumber <- function(block_number, rpc_address = "http://localhost:8545"){
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getBlockTransactionCountByNumber"), 
                           params = c(block_number),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                                httr::add_headers("Content-Type" = "application/json"),
                                body = post_body)
  
  block_trans <- httr::content(post_return)$result
  
  return(block_trans)
}


#' eth_getCode
#'
#' Returns code at a given address.
#'
#' @param 20 Bytes - address.
#' @param hex value of block number, or the string "latest", "earliest" or "pending".
#' @param rpc_address The address of the RPC API.
#' @return the code from the given address.
#' @export
eth_getCode <- function(address, block_number, rpc_address = "http://localhost:8545") {
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getCode"), 
                           params = c(address, block_number),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                            httr::add_headers("Content-Type" = "application/json"),
                            body = post_body)
  
  post_content <- httr::content(post_return, as = "parsed")
  
  code <- post_content$result
  
  return(code)
}


#' eth_getBlockByHash
#'
#' Returns information about a block from a hash.
#'
#' @param block_hash 32 Bytes - Hash of a block.
#' @param full_list Boolean - True = returns the full transaction objects, FALSE = only the hashes of the transactions.
#' @param rpc_address The address of the RPC API.
#' @return number: QUANTITY - the block number. null when its pending block.
#' @return hash: DATA, 32 Bytes - hash of the block. null when its pending block.
#' @return parentHash: DATA, 32 Bytes - hash of the parent block.
#' @return nonce: DATA, 8 Bytes - hash of the generated proof-of-work. null when its pending block.
#' @return sha3Uncles: DATA, 32 Bytes - SHA3 of the uncles data in the block.
#' @return logsBloom: DATA, 256 Bytes - the bloom filter for the logs of the block. null when its pending block.
#' @return transactionsRoot: DATA, 32 Bytes - the root of the transaction trie of the block.
#' @return stateRoot: DATA, 32 Bytes - the root of the final state trie of the block.
#' @return receiptsRoot: DATA, 32 Bytes - the root of the receipts trie of the block.
#' @return miner: DATA, 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
#' @return difficulty: QUANTITY - integer of the difficulty for this block.
#' @return totalDifficulty: QUANTITY - integer of the total difficulty of the chain until this block.
#' @return extraData: DATA - the "extra data" field of this block.
#' @return size: QUANTITY - integer the size of this block in bytes.
#' @return gasLimit: QUANTITY - the maximum gas allowed in this block.
#' @return gasUsed: QUANTITY - the total used gas by all transactions in this block.
#' @return timestamp: QUANTITY - the unix timestamp for when the block was collated.
#' @return transactions: Array - Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter.
#' @return uncles: Array - Array of uncle hashes.
#' @export
eth_getBlockByHash <-function(block_hash, full_list = FALSE,
                              rpc_address = "http://localhost:8545") {
  
  full_list <- tolower(as.character(full_list))
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getBlockByHash"), 
                           params = c(block_hash, full_list),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                                  httr::add_headers("Content-Type" = "application/json"),
                                  body = post_body)
  
  block_data <- httr::content(post_return)$result
  
  return(block_data)
}


#' eth_getBlockByNumber
#'
#' Returns information about a block from the block number.
#'
#' @param rpc_address The address of the RPC API.
#' @param block_number hex value of a block number, or the string "earliest", "latest" or "pending".
#' @param full_list Boolean - TRUE = full transaction objects, FALSE = only hashes of trasactions.
#'
#' @return number: QUANTITY - the block number. null when its pending block.
#' @return hash: DATA, 32 Bytes - hash of the block. null when its pending block.
#' @return parentHash: DATA, 32 Bytes - hash of the parent block.
#' @return nonce: DATA, 8 Bytes - hash of the generated proof-of-work. null when its pending block.
#' @return sha3Uncles: DATA, 32 Bytes - SHA3 of the uncles data in the block.
#' @return logsBloom: DATA, 256 Bytes - the bloom filter for the logs of the block. null when its pending block.
#' @return transactionsRoot: DATA, 32 Bytes - the root of the transaction trie of the block.
#' @return stateRoot: DATA, 32 Bytes - the root of the final state trie of the block.
#' @return receiptsRoot: DATA, 32 Bytes - the root of the receipts trie of the block.
#' @return miner: DATA, 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
#' @return difficulty: QUANTITY - integer of the difficulty for this block.
#' @return totalDifficulty: QUANTITY - integer of the total difficulty of the chain until this block.
#' @return extraData: DATA - the "extra data" field of this block.
#' @return size: QUANTITY - integer the size of this block in bytes.
#' @return gasLimit: QUANTITY - the maximum gas allowed in this block.
#' @return gasUsed: QUANTITY - the total used gas by all transactions in this block.
#' @return timestamp: QUANTITY - the unix timestamp for when the block was collated.
#' @return transactions: Array - Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter.
#' @return uncles: Array - Array of uncle hashes.
#' @export
eth_getBlockByNumber <-function(block_number, full_list = FALSE, rpc_address = "http://localhost:8545") {
  
  full_list <- tolower(as.character(full_list))
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getBlockByNumber"), 
                           params = c(block_number, full_list),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                             httr::add_headers("Content-Type" = "application/json"),
                             body = post_body)
  
  block_data <- httr::content(post_return)$result
  
  return(block_data)
}


#' eth_getTransactionByHash
#'
#' Returns the information about a transaction requested by transaction hash.
#'
#' @param transaction_hash 32 Bytes - hash of a transaction.
#' @param rpc_address The address of the RPC API.
#' @return List of transaction properties, or null when no transaction found.
#' @return hash: DATA, 32 Bytes - hash of the transaction.
#' @return nonce: numeric - the number of transactions made by the sender prior to this one.
#' @return blockHash: DATA, 32 Bytes - hash of the block where this transaction was in. null when its pending.
#' @return blockNumber: QUANTITY - block number where this transaction was in. null when its pending.
#' @return transactionIndex: QUANTITY - integer of the transactions index position in the block. null when its pending.
#' @return from: DATA, 20 Bytes - address of the sender.
#' @return to: DATA, 20 Bytes - address of the receiver. null when its a contract creation transaction.
#' @return value: QUANTITY - value transferred in Wei.
#' @return gasPrice: QUANTITY - gas price provided by the sender in Wei.
#' @return gas: QUANTITY - gas provided by the sender.
#' @return input: DATA - the data send along with the transaction.
#' @export
eth_getTransactionByHash <- function(transaction_hash, rpc_address = "http://localhost:8545") {
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getTransactionByHash"), 
                           params = c(transaction_hash),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                            httr::add_headers("Content-Type" = "application/json"),
                            body = post_body)
  
  post_content <- httr::content(post_return, as = "parsed")
  
  transaction_data <- post_content$result
  
  return(transaction_data)
}


#' eth_getTransactionByBlockHashAndIndex
#'
#' Returns information about a transaction by block hash and transaction index position.
#'
#' @param block_hash 32 Bytes - hash of a block.
#' @param index_number integer of the transaction index position.
#' @param rpc_address The address of the RPC API.
#' @return List of transaction properties, or null when no transaction found
#' @export
eth_getTransactionByBlockHashAndIndex <- function(block_hash, index_number = "0x0", 
                                                  rpc_address = "http://localhost:8545") {

  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getTransactionByBlockHashAndIndex"), 
                           params = c(block_hash, index_number),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                            httr::add_headers("Content-Type" = "application/json"),
                            body = post_body)
  
  post_content <- httr::content(post_return, as = "parsed")
  
  transaction_data <- post_content$result
  
  return(transaction_data)
}


#' eth_getTransactionByBlockNumberAndIndex
#'
#' Returns information about a transaction by block number and transaction index position.
#'
#' @param block_number a hex block number, or the string "earliest", "latest" or "pending".
#' @param index_number integer of the transaction index position.
#' @param rpc_address The address of the RPC API.
#' @return List of transaction properties, or null when no transaction found
#' @return hash: DATA, 32 Bytes - hash of the transaction.
#' @return nonce: numeric - the number of transactions made by the sender prior to this one.
#' @return blockHash: DATA, 32 Bytes - hash of the block where this transaction was in. null when its pending.
#' @return blockNumber: QUANTITY - block number where this transaction was in. null when its pending.
#' @return transactionIndex: QUANTITY - integer of the transactions index position in the block. null when its pending.
#' @return from: DATA, 20 Bytes - address of the sender.
#' @return to: DATA, 20 Bytes - address of the receiver. null when its a contract creation transaction.
#' @return value: QUANTITY - value transferred in Wei.
#' @return gasPrice: QUANTITY - gas price provided by the sender in Wei.
#' @return gas: QUANTITY - gas provided by the sender.
#' @return input: DATA - the data send along with the transaction.
#' @export
eth_getTransactionByBlockNumberAndIndex <- function(block_number, index_number = "0x0",
                                                    rpc_address = "http://localhost:8545") {
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getTransactionByBlockNumberAndIndex"), 
                           params = c(block_number, index_number),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                            httr::add_headers("Content-Type" = "application/json"),
                            body = post_body)
  
  post_content <- httr::content(post_return, as = "parsed")
  
  transaction_data <- post_content$result
  
  return(transaction_data)
}


#' eth_getTransactionReceipt
#'
#' Returns the receipt of a transaction by transaction hash.
#'
#' @param transaction_hash 32 Bytes - hash of a transaction.
#' @param rpc_address The address of the RPC API.
#' @return transationHash: DATA, 32 Bytes - hash of the transaction.
#' @return transactionIndex: QUANTITY - integer of the transactions index position in the block. null when its pending.
#' @return blockHash: DATA, 32 Bytes - hash of the block where this transaction was in. null when its pending.
#' @return blockNumber: QUANTITY - block number where this transaction was in. null when its pending.
#' @return cumulativeGasUsed: QUANTITY - The total amount of gas used when this transaction was executed in the block.
#' @return gasUsed: QUANTITY - The amount of gas used by this specific transaction alone.
#' @return vcontractAddress: DATA, 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null.
#' @return logs: Array - Array of log objects, which this transaction generated.
#' @export
eth_getTransactionReceipt <- function(transaction_hash, rpc_address = "http://localhost:8545") {
  
  post_body <- jsonlite::toJSON(list(jsonrpc = jsonlite::unbox("2.0"), 
                           method = jsonlite::unbox("eth_getTransactionReceipt"), 
                           params = c(transaction_hash),
                           id = jsonlite::unbox(1)))
  
  post_return <- httr::POST(url = rpc_address,
                                    httr::add_headers("Content-Type" = "application/json"),
                                    body = post_body)
  
  post_content <- httr::content(post_return)$result
  
  return(post_content)
}





