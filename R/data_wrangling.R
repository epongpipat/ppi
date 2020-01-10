data_wrangling <- function(psy_events_data, psy_contrast_table, phys_data,
                           detrend_factor, hrf_name, tr, n_volumes,
                           upsample_factor = NULL, deconvolve = TRUE,
                           nuisance_var = NULL) {
  data_wrangling <- list()
  data_wrangling$hrf <- create_hrf_afni(hrf_name, tr, upsample_factor)
  data_wrangling$psy_var <- create_psy_var(psy_events_data, psy_contrast_table,
                                           data_wrangling$hrf, tr, n_volumes,
                                           upsample_factor)
  data_wrangling$phys_var <- create_phys_var(phys_data, detrend_factor,
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
