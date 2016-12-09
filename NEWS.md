# ethr 0.9.13

## Update

## New

* Parity support (woohoo!)
* Added UNIX timestamp and count of uncles to getBlockHeader data.frame
* Added blNumberOfTransactions to getBlockHeader
* Bug fixes (#5, )

# ethr 0.9.12

## Update

We have removed some of the more complex functions as we redesign and update the pacakge, this is in part due to compatibility issues and also wanted a simple package to interface with. Work is continuing on the a final v1.0 release which will encapsulate most of the RPC methods available and a couple of basic convenience functions. If you still require the previous functions then you should be able to use an older version to access them still, contact us if you are having any problems.

## New

* Changed some documentation for using both the Parity and Geth Ethereum clients.

# ethr 0.9.11

## New

* News file!
* Simplified .readme - Moved example code to 'exmaples' vignette, to be expanded at a later date

## Bug fixes and corrections

* Typos in README.md (#1)
* bulkBlockDownload.R now creates 'ethr_blocks' folder automatically (#2)
