detrend <- function(in_file, degree = 2, out_file, overwrite = F) {
  if (!file.exists(in_file)) {
    stop(paste0(in_file, " does not exist."))
  }

  if (file.exists(out_file) & overwrite == F) {
    stop(paste0(out_file), " already exists and overwrite option is set to FALSE.")
  }

  if (!is.integer(degree)) {
    stop(paste0(degree), " must be an integer.")
  }

  require(xfun)
  packages <- c("readr", "dplyr", "broom")
  xfun::pkg_attach(packages, message = F, install = T)
  x <- read_csv(in_file)
  y <- lm(in_file ~ poly(1:length(x), degree)) %>%
    augment() %>%
    select(residual = .resid)
  write_csv(y, out_file, col_names = F)
}
