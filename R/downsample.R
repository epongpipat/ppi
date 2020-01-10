#' @title downsample
#' @concept data_wrangling
#' @param data data to be upsampled
#' @param downsample_factor factor to downsample data
#'
#' @return
#' @export
#' @import readr
#' @examples
#' # to be added
downsample <- function(data, downsample_factor) {

  if (!is.numeric(downsample_factor) || downsample_factor <= 0) {
    stop("downsample_factor must be a greater than 1")
  }

  data <- as.matrix(data[seq(1, length(data), downsample_factor)])

  return(data)

}
