'ethr' - An Ethereum Package for R
================

-   [Description](#description)
-   [Installation](#installation)
-   [Setup](#setup)
-   [Base Functions](#base-functions)
-   [Helper functions](#helper-functions)
-   [Examples](#examples)

Description
===========

The 'ethr' R package is an interface for accessing Ethereum blockchain data in R, querying the Ethereum Blockchain via the JSON-RPC API.

ethr provides several convenience and helper functions, such as:

-   Handling of hexadecimal conversion
-   Access block data
-   Access transaction data/transaction receipts
-   Bulk download management

Installation
============

The package will be submitted to CRAN soon, until then you can install it from Github using devtools:

``` r
# install.packages("devtools")
devtools::install_github("BSDStudios/ethr")
```

Setup
=====

Data is extracted from your local `chaindata` folder using a running geth instance, see <https://github.com/ethereum/go-ethereum/wiki/Getting-Geth> for details.

note: ensure that you have added the `--rpc --rpccorsdomain localhost` options when initialising geth to ensure that the package can access the JSON-RPC API.

Base Functions
==============

These base functions are direct implementations of the available JSON-RPC methods detailed here, <https://github.com/ethereum/wiki/wiki/JSON-RPC> and replicate their functionality as much as possible.

-   eth\_coinbase - Returns the client coinbase address.
-   eth\_gasPrice - Returns the current price per gas in wei.
-   eth\_accounts - Returns a list of addresses owned by client.
-   eth\_blockNumber - Returns the number of most recent block.
-   eth\_getBalance - Returns the balance of the account of given address.
-   eth\_getStorageAt - Returns the value from a storage position at a given address.
-   eth\_getTransactionCount - Returns the number of transactions sent from an address at given block number.
-   eth\_gethBlockTransactionCountByHash - Returns the number of transactions in a block, given the block hash.
-   eth\_getBlockTransactionCountByNumber - Returns the number of transactions in a block the given block number.
-   eth\_getCode - Returns code at a given address.
-   eth\_getBlockByHash - Returns information about a block from a hash.
-   eth\_getBlockByNumber - Returns information about a block from the block number.
-   eth\_getTransactionByHash - Returns the information about a transaction requested by transaction hash.
-   eth\_getTransactionByBlockHashAndIndex - Returns information about a transaction by block hash and transaction index position.
-   eth\_getTransactionByBlockNumberAndIndex - Returns information about a transaction by block number and transaction index position.
-   eth\_getTransactionReceipt - Returns the receipt of a transaction by transaction hash.

Helper functions
================

These functions use the base function, queering the blockchain, but make it easier for the user to download larger chunks of data and to have more control over where those chunks are taken from.

-   getBockTransations will return a data frame of the transactions for either a given number of blocks or a specified range of blocks.

-   getBlockHeaders will return just the block header data for a given number of blocks or specified range of blocks.getBlockHeaders will return just the block header data for a given number of blocks or specified range of blocks.

-   getTransactionInTimeFrame will return the block numbers closest to two given times and dates. (This can be then input into getBockTransations to get the transactions during this time period.)

-   bulkBlockDownload.R breaks a large block range up and manages the download size. All downloaded blocks will be stored in a ethr\_blocks folder in the data\_dir.

-   getBlockRange - Returns the minimum and maximum blocks that are currently downloaded for the analysis table. Note: this does not check for continuity, only returns min and max vales.

-   nodesPlot - creates a basic node plot showing the transactions and accounts within the input data frame. Accounts with high in- or -out degree (i.e. receive or sent large number of transactions) can be highlighted and the threshold for that transaction level set. Also large transactions (more than 3x standard deviations from mean transaction value) are highlighted.

Examples
========

See the 'examples' vignette for details.
