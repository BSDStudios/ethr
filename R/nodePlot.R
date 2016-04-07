#' nodesPlots
#'
#' @description Plots the nodes/accounts and transaction between said accounts for input transactions data.
#' The nodes with high in and out degree activity are coloured. The threshold value is 10. 
#' Large transactions (greater than 3 standard deviation from the mean transaction value) are shown with black arrows.
#'
#' @param table, dataframe containing transactions, eg output from getBlockTransactions
#' @param degree_thres numeric, number of transactions, used to select nodes with high in- or out-degrees.
#' @param save_plot, save the plot to disk. Default is FALSE.
#'
#' @return plot of the nodes and transaction for the input data.
#' @import igraph
#' @export
#'
#' @examples
#' nodesPlot(transactions)
#' nodesPlot(transaction,degree_thres=50,save_plot=TRUE)
nodesPlot <- function(table = transactions,degree_thres = 10, save_plot=FALSE){
  
  if(!is.data.frame(table)){
    stop("Please enter a data frame of transactions")
  }else{
    data <- table
  }
  
  freq_from <- as.data.frame(table(data$trFrom))
  freq_to   <- as.data.frame(table(data$trTo))
  ind_to   <- which(freq_to[,2]>degree_thres)
  ind_from <- which(freq_from[,2]>degree_thres)
  
  #address with high out-degree
  address_to <- as.vector(freq_to[ind_to,1])
  #address with high in-degree
  address_from <- as.vector(freq_from[ind_from,1])
  addresses <- c(address_to,address_from)

  #### start preparing data and putting in format to plot
  nodesg2 <- data.frame()
  nodesg2 <- rbind(nodesg2,data.frame(from=data$trFrom, to=data$trTo,value=data$trValueEth))
  btcg2 <- ddply(nodesg2, c("from", "to"), summarize, value=sum(value))


  
  btcg2.net <- igraph::graph.data.frame(btcg2, directed=T)
  V(btcg2.net)$color <- "blue"
  V(btcg2.net)$size <- 3
  #### color nodes according to sending for recieving transactions
  for(i in 1:length(address_to)){
    V(btcg2.net)$color[unlist(V(btcg2.net)$name) == address_to[i]] <- "red"
    V(btcg2.net)$size[unlist(V(btcg2.net)$name) == address_to[i]] <- 8
  }
  for(i in 1:length(address_from)){
    V(btcg2.net)$color[unlist(V(btcg2.net)$name) == address_from[i]] <- "green3"
    V(btcg2.net)$size[unlist(V(btcg2.net)$name) == address_from[i]] <- 8
  }


  ####Color vertices according to transaction size. If transaction is greater than 3*sd from the mean 
  #### transaction value, the arrow is black. Otherwise it is grey.
  arrow_col <- vector()
  arrow_size <- vector()
  arrow_width <- vector()
  meanVal <- mean(btcg2$value)
  sdVal <- sd(btcg2$value)
  for(i in 1:dim(btcg2)[1]){
    if(btcg2$value[i] < 3*sdVal){
      arrow_col[i] <- "dodgerblue2"
      arrow_size[i] <- 0.5
      arrow_width[i] <- 1
    }else{
      arrow_col[i] <- "black"
      arrow_size[i] <- 1
      arrow_width[i] <- 2.5
    }    
  }

  nodes <- unlist(V(btcg2.net)$name)
  E(btcg2.net)$width <- 1

  #Add legend info
  leg.txt <- c("high In-degree","high Out-degree",
               "other accounts","large transaction")
  if(save_plot == FALSE){
    # x11()
     igraph::plot.igraph(btcg2.net,edge.arrow.size=0.2,edge.color= arrow_col,
                         edge.width=arrow_width,
                         vertex.label=NA, main=paste("Node mapping"),margin=c(0,0,0,0))
      legend("bottomleft",leg.txt,
              col=c("red","green3","blue","black"),
               pch=c(19,19,19,NA), lty=c(NA,NA,NA,1) ,cex=0.65,bty="n")
  }else{
      png(file="nodesmap.png",width=800,height=800,res=100)
      igraph::plot.igraph(btcg2.net,edge.arrow.size=arrow_size,edge.color= arrow_col,
                          edge.width=arrow_width,
                          vertex.label=NA, main=paste("Node mapping"),margin=c(0,0,0,0))
      legend("bottomleft",leg.txt,
            col=c("red","green3","blue","black"),
            pch=c(19,19,19,NA), lty=c(NA,NA,NA,1) ,cex=0.8,bty="n")
      dev.off()
    }

}
