#' @title create_phys_var
#' @description creates data for each wrangling step of the physiological variable using the data wrangling functions: \code{detrend()}, \code{upsample()}, and \code{deconvolve_afni()}
#' @concept data_wrangling_wrapper_functions
#' @param phys time series data
#' @param detrend_factor factor to detrend the time series
#' @param upsample_factor factor to upsample the time series for the deconvolution step (default: NULL)
#' @param hrf hemodynamic response function (hrf) time series data
#' @param afni_path path to afni directory (default: NULL)
#' @return a list of datasets for each data wrangling step of the physiological variables
#' @export
#'
#' @examples
#' # to be added
create_phys_var <- function(phys, detrend_factor, upsample_factor = NULL, hrf, afni_path = NULL) {
  phys_list <- list()
  phys_list$detrend <- detrend(phys, detrend_factor) %>% as.data.frame() %>% rename(phys = residual)
  phys_list$upsample <- upsample(phys_list$detrend, upsample_factor) %>% as.data.frame()
  colnames(phys_list$upsample) <- "phys"
  phys_list$deconvolve <- deconvolve_afni(phys_list$upsample, hrf, afni_path) %>% as.data.frame()
  colnames(phys_list$deconvolve) <- "phys"
  return(phys_list)
}
