#' @title detrend
#' @concept data_wrangling
#'
#' @param data data to be detrended
#' @param degree degree for data to be detrended
#'
#' @return detrended data
#' @export
#' @import readr dplyr broom
#' @examples
detrend <- function(data, degree) {

  if (degree < 0 || !is.numeric(degree)) {
    stop("degree must be an positive integer greater than or equal to 1")
  }

  residual <- apply(as.matrix(data), 2, function(x) lm(x ~ poly(1:length(x), degree)) %>% augment() %>% select(residual = .resid))

  return(residual)

}
