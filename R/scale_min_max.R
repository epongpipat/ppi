#' @title scale_min_max
#'
#' @param data data to scale
#' @param min minimum value of the data (default: NULL)
#' @param max maximum value of the data (default: NULL)
#'
#' @return
#' @export
#'
#' @examples
scale_min_max <- function(data, min = NULL, max = NULL) {

  if (is.null(min)) {
    min <- min(data)
  }

  if (is.null(max)) {
    max <- max(data)
  }

  scaled_data <- (data - min) / (max - min)

  return(scaled_data)

}
