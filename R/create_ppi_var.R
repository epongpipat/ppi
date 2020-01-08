create_ppi_var <- function(psy_var, phys_var, hrf, tr, n_volumes, upsample_factor = NULL, deconvolve = TRUE) {
  ppi_list <- list()
  ppi_list$interaction <- apply(psy_var, 2, phys_var)

  if (deconvolve == TRUE) {
    ppi_list$convolve <- apply(ppi_list$interaction, 2, function(x) convolve_afni(x, hrf, tr, n_volumes, upsample_factor))
    ppi_list$downsample <- apply(ppi_list$convolve, 2, function(x) downsample(x, upsample_factor))
  } else if (deconvolve == FALSE) {
    ppi_list$downsample <- apply(ppi_list$interaction, 2, function(x) downsample(x, upsample_factor))
  }

  return(ppi_list)
}
