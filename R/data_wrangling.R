data_wrangling <- function(events, contrast_table, hrf_name, phys,
                           detrend_factor, tr, n_volumes, upsample_factor,
                           deconvolve, nuisance_var) {
  data_wrangling <- list()
  data_wrangling$hrf <- get_hrf_afni(hrf_name, tr, upsample_factor)
  data_wrangling$psy_var <- create_psy_var(events, contrast_table, data_wrangling$hrf, tr,
                                           n_volumes, upsample_factor)
  data_wrangling$phys_var <- create_phys_var(phys, detrend_factor,
                                             upsample_factor, data_wrangling$hrf)

  if (deconvolve == TRUE) {
    data_wrangling$ppi_var <- create_ppi_var(data_wrangling$psy_var$upsample,
                                             data_wrangling$phys_var$deconvolve,
                                             data_wrangling$hrf, tr, n_volumes,
                                             upsample_factor, deconvolve)
  } else if (deconvolve == FALSE) {
    data_wrangling$ppi_var <- create_ppi_var(data_wrangling$psy_var$upsample,
                                             data_wrangling$phys_var$upsample,
                                             data_wrangling$hrf, tr, n_volumes,
                                             upsample_factor, deconvolve)
  }

  data_wrangling$design_matrix <- create_design_matrix(data_wrangling$psy_var$downsample,
                                                       data_wrangling$phys_var$detrend,
                                                       data_wrangling$ppi_var$downsample,
                                                       nuisance_var)

  return(data_wrangling)
}
