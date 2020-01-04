contrast_code_categorical_variable <- function(in_file, in_contrast_code_file, out_file, overwrite = F) {
  if (!file.exists(in_file)) {
    stop(paste0(in_file, " does not exist."))
  }

  if (!file.exists(in_contrast_code_file)) {
    stop(paste0(in_contrast_code_file, " does not exist."))
  }

  if (file.exists(out_file) & overwrite == F) {
    stop(paste0(out_file), " already exists and overwrite option is set to FALSE.")
  }

  # read files
  x <- read_csv(in_file, col_names = F)
  c <- read_csv(in_contrast_code_file, col_names = T)

  # apply contrast
  contrasts(x) <- c

  # create design matrix
  o <- model.matrix(~ x) %>%
    as_tibble() %>%
    select(-"(Intercept)")
  colnames(o) <- colnames(c)

  # write file
  write_csv(x, out_file)
}
