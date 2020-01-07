downsample <- function(data, downsample_factor) {

  if (!is.numeric(downsample_factor) || downsample_factor <= 0) {
    stop("downsample_factor must be a greater than 1")
  }

  require(xfun)
  packages <- c("readr")
  xfun::pkg_attach(packages, message = F, install = T)

  data <- as.matrix(data[seq(1, length(data), downsample_factor)])

  return(data)

}
