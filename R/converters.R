#' Convert hex to decimal value
#'
#' @param hex character, hex value, '0x' prefixed.
#' @return numeric, decimal equivalent
#' @export
hexDec <- function(hex) {Rmpfr::mpfr(hex, base=16)}


#' Convert decimal to hex value
#' 
#' @param dec numeric or character, an integer value formatted as character if
#'   over 32bit max (2147483647).
#' @return character, hex equivalent, '0x' prefixed.
#' @export
decHex <- function(dec) {
  
  dmax <- 2147483647
  
  if(is.numeric(dec) && (dec > dmax)) {
    stop("Numbers greater than 32bit max (2147483647) should be 
         formatted as type \"character\" to preserve precision.")
  }
  
  result <- paste0("0x",as.character(gmp::as.bigz(dec),b=16))
  return(result)
}


#' Convert Ethereum Denominations
#' 
#' @param x numeric, number to be converted
#' @param from character, 2 letter short notation to convert from (see details)
#' @param to character, 2 letter short notation to convert to (see details)
#'   
#' @return mpfr converted value (see details)
#' @export
#' 
#' @examples
#' ethCon(15000000000000000, "we", "et")
#' ethCon(1000000000, "et", "me")
#' @details This function returns a Multiple Precision Floating-Point Reliable
#' number (implemented by the Rmpfr package). This is to allow for the conersion
#' of very high values of Wei into other forms. This can then be converted to
#' numeric, integer or double as required at the expense of accuracy. WARNING do
#' not use this in calculating values to transact actual ether as the precision is not
#' guaranteed currently. This is intended for indicative conversions when parsing
#' data from the Ethereum blockchain. \cr
#' \cr
#' Denomination short codes:\cr
#' wei = we, Kwei = kw, Mwei = mw,  Gwei = gw \cr
#' szabo = sz, finney = fi, ether = et \cr
#' Kether = ke, Mether = me,Gether = ge, Tether = te \cr
ethCon <- function(x, from, to) {
  
  data("conversion_table")
  
  a <- conversion_table[(conversion_table$short == from), ]$conversion
  a <- Rmpfr::mpfr(a, Rmpfr::getPrec(a))
  b <- conversion_table[(conversion_table$short == to), ]$conversion
  b <- Rmpfr::mpfr(b, Rmpfr::getPrec(b))
  
  result <- x * (b/a)
  
  return(result)
}

















