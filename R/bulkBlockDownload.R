#' Bulk Block Download
#' 
#' Breaks a large block range up and manages the download size. All downloaded 
#' blocks will be stored in a \code{ethr_blocks} folder in the \code{data_dir}. 
#' Uses doParallel package to create a multithread workgroup to increase 
#' download speed.
#' 
#' @param start_block numeric, Starting block number.
#' @param end_block numeric, Ending block number.
#' @param data_dir path, Desired folder for storing analysis table in.
#' @param chunk_size numeric, Chunk size to Download.
#' @param parallel logical, Should plyr operate in parallel.
#' @param cores numeric, number of cores to be intialised. Suggested n - 1, 
#'   where n is localhosts number of cores.
#'   
#' @return saves .RData file within \code{ethr_blocks} folder in the 
#'   \code{data_dir}.
#' @export
bulkBlockDownload <- function(start_block, end_block, data_dir, chunk_size = 50000,
                              parallel = TRUE, cores = 3) {
  
  dir.create(file.path(paste0(data_dir, "/ethr_blocks")), showWarnings = FALSE)
  
  workers <-parallel::makeCluster(cores)
  doParallel::registerDoParallel(workers)
  
  length_out <- ceiling((end_block-start_block)/chunk_size) + 1
  block_seq <- floor(seq(from = end_block, to = start_block, length.out = length_out))
  
  for (i in 1:(length(block_seq) - 1)) {
    st <- block_seq[i + 1]
    en <- block_seq[i] - 1
    block_chunk <- getBlockTransactions(start_block = st, end_block = en, parallel = parallel)
    save(block_chunk, file = paste0(data_dir, "ethr_blocks/", st, "-", en, ".rda"))
    print(paste0("Blocks downloaded: starting: ", st, ", ending: ", en))
  }
  
}


#' Combine Downloaded Transaction Chunks
#' 
#' Reads all .RData files within \code{ethr_blocks} and combines them into a
#' single data.frame for analysis.
#' 
#' @param data_dir path, Desired folder for storing analysis table in.
#'   
#' @return a tbl_df of the combined download chunks stored in \code{ethr_blocks}.
#' @export
combineDownloadedBlocks <- function(data_dir) {
  
  file_list <- list.files(path = paste0(data_dir, "ethr_blocks"), pattern = ".rda")
  
  if(length(file_list) == 0) {
    warning(paste("No '.RDA' files present in", data_dir))
    return(NA)
  }
  
  analysis_table <- 
    rbind(plyr::ldply(.data = file_list,
                      .fun = function(blDownload) {
                        block_data <- get(load(paste0(data_dir, "ethr_blocks/", blDownload)))
                        i <- sapply(block_data, is.factor)
                        block_data[i] <- lapply(block_data[i], as.character)
                        print(paste(blDownload, "loaded"))
                        return(block_data)
                      }))
  
  analysis_table <- dplyr::tbl_df(analysis_table)
  
  return(analysis_table)
}


#' Get Downloaded Block Range
#' 
#' Returns the minimum and maximuim blocks that are currently downloaded for the
#' analysis table. NOTE,this does not check for continuity, only returns min and
#' max vales.
#' 
#' @param data_dir path, Desired folder for storing analysis table in.
#'   
#' @return list min, max numerics of the blocks already downloaded.
#' @export
getBlockRange <- function(data_dir) {
  file_list <- list.files(path = paste0(data_dir, "ethr_blocks"), pattern = ".rda")
  file_list <- unlist(strsplit(file_list, split = ".rda"))
  file_list <- sort(as.numeric(unlist(strsplit(file_list, split = "-"))))
  min_block <- min(file_list)
  max_block <- max(file_list)
  range <- list(min = min_block, max = max_block)
  return(range)
}