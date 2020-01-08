create_ppi_var <- function(psy_var, phys_var, hrf, tr, n_volumes, upsample_factor = NULL, deconvolve = TRUE) {
  ppi_list <- list()
  ppi_list$interaction <- apply(as.matrix(psy_var), 2, function(x) x * as.matrix(phys_var)) %>% as.data.frame()
  colnames(ppi_list$interaction) <- str_replace(colnames(ppi_list$interaction), "psy_", "ppi_")
  if (deconvolve == TRUE) {
    ppi_list$convolve <- apply(ppi_list$interaction, 2, function(x) convolve_afni(x, hrf, tr, n_volumes, upsample_factor)) %>% as.data.frame()
    ppi_list$downsample <- apply(ppi_list$convolve, 2, function(x) downsample(x, upsample_factor)) %>% as.data.frame()
  } else if (deconvolve == FALSE) {
    ppi_list$downsample <- apply(ppi_list$interaction, 2, function(x) downsample(x, upsample_factor)) %>% as.data.frame()
  }

  return(ppi_list)
}
