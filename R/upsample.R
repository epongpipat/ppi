upsample <- function(data, upsample_factor) {

  if (!is.numeric(upsample_factor) || upsample_factor <= 0) {
    stop("upsample_factor must be an integer greater than 1")
  }

  require(xfun)
  packages <- c("readr")
  xfun::pkg_attach(packages, message = F, install = T)

  #data <- df_phys$data[[1]]$data
  #upsample_factor <- 16

  new_data <- NULL
  for (i in 1:length(data)) {
    temp_start <- data[i]

    if (i == length(data)) {
      temp_end <- data[i]
    } else {
      temp_end <- data[i+1]
    }

      temp_data <- seq(temp_start, temp_end, length.out = (upsample_factor + 1))
      temp_data <- temp_data[-length(temp_data)]
      new_data <- c(new_data, temp_data)
  }

  #data <- rep(data, each = upsample_factor)

  return(new_data)

}
