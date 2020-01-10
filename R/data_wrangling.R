#' @title data_wrangling
#' @description uber data wrangling wrapper function to create data for each step of data wrangling for each psy, phys, and ppi variables to ultimately create the design matrix. This function is a wrapper of \code{create_hrf_afni()}, \code{create_psy_var()}, \code{create_phys_var()}, \code{create_ppi_var()}, and \code{create_design_matrix()}
#' @concept data_wrangling_uber_functions
#' @param psy_events_data events data with columns of onset, duration, and trial_type
#' @param psy_contrast_table contrast code
#' @param phys_data time series data of physiological variable (seed ROI)
#' @param detrend_factor factor to detrend time series
#' @param hrf_name name of hemodynamic response function (hrf) to use during convolution and deconvolution step
#' @param tr repition time (tr) in seconds
#' @param n_volumes number of volumes or time points
#' @param upsample_factor factor to upsample psy and phys data for convolution and deconvolution step (default: NULL)
#' @param deconvolve perform deconvolution of phys and convolve of ppi term (also known as deconvolve-convolve or reconvolve step)
#' @param nuisance_var data of nuisance variables to include in design matrix
#' @param afni_path path to afni directory (default: NULL)
#' @return
#' @export
#'
#' @examples
#' # to be added
data_wrangling <- function(psy_events_data, psy_contrast_table, phys_data,
                           detrend_factor, hrf_name, tr, n_volumes,
                           upsample_factor = NULL, deconvolve = TRUE,
                           nuisance_var = NULL, afni_path = NULL) {
  data_wrangling <- list()
  data_wrangling$hrf <- create_hrf_afni(hrf_name, tr, upsample_factor)
  data_wrangling$psy_var <- create_psy_var(psy_events_data, psy_contrast_table,
                                           data_wrangling$hrf, tr, n_volumes,
                                           upsample_factor, afni_path)
  data_wrangling$phys_var <- create_phys_var(phys_data, detrend_factor,
                                             upsample_factor, data_wrangling$hrf, afni_path)

  if (deconvolve == TRUE) {
    data_wrangling$ppi_var <- create_ppi_var(data_wrangling$psy_var$upsample,
                                             data_wrangling$phys_var$deconvolve,
                                             data_wrangling$hrf, tr, n_volumes,
                                             upsample_factor, deconvolve, afni_path)
  } else if (deconvolve == FALSE) {
    data_wrangling$ppi_var <- create_ppi_var(data_wrangling$psy_var$upsample,
                                             data_wrangling$phys_var$upsample,
                                             data_wrangling$hrf, tr, n_volumes,
                                             upsample_factor, deconvolve, afni_path)
  }

  data_wrangling$design_matrix <- create_design_matrix(data_wrangling$psy_var$downsample,
                                                       data_wrangling$phys_var$detrend,
                                                       data_wrangling$ppi_var$downsample,
                                                       nuisance_var)

  return(data_wrangling)
}
