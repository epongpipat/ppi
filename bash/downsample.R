upsample <- function(in_file, out_file, downsample_factor, overwrite = F) {
  if (!file.exists(in_file)) {
    stop(paste0(in_file, " does not exist."))
  }

  if (file.exists(out_file) & overwrite == F) {
    stop(paste0(out_file), " already exists and overwrite option is set to FALSE.")
  }

  if (!is.integer(downsample_factor)) {
    stop(paste0(downsample_factor), " must be an integer.")
  }

  require(xfun)
  packages <- c("readr")
  xfun::pkg_attach(packages, message = F, install = T)
  x <- read_csv(in_file)
  x <- x[seq(1, length(x), downsample_factor)]
  write_csv(x, out_file, col_names = F)
}
