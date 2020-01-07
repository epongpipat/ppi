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
