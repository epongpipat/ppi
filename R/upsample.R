upsample <- function(data, upsample_factor) {

  if (!is.numeric(upsample_factor) || upsample_factor <= 0) {
    stop("upsample_factor must be an integer greater than 1")
  }

  require(xfun)
  packages <- c("readr")
  xfun::pkg_attach(packages, message = F, install = T)

  data <- rep(data, each = upsample_factor)

  return(data)

}
