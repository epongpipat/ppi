detrend <- function(data, degree) {

  if (degree < 0 || !is.numeric(degree)) {
    stop("degree must be an positive integer greater than or equal to 1")
  }

  if (is.matrix(data) || is.data.frame(data)) {
    data <- data[, 1]
  }

  require(xfun)
  packages <- c("readr", "dplyr", "broom")
  xfun::pkg_attach(packages, message = F, install = T)

  residual <- lm(data ~ poly(1:length(data), degree)) %>%
    augment() %>%
    select(residual = .resid)

  return(residual)

}
