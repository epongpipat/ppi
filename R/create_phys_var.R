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
#' df <- read_csv("examples/sub-control01_task-music_run-1_bold_space-subj_vox-32-24-38")
#' phys_ts_file <- "examples/sub-control01_task-music_run-1_bold_space-subj_vox-32-24-38.csv"
#' phys_ts <- read.csv(phys_ts_file, header = F)
#' hrf <- create_hrf_afni("spmg1", 3, NULL)
#' phys_var <- create_phys_var(phys_ts_file, 2, 16, hrf)
#' summary(test)
create_phys_var <- function(phys, detrend_factor, upsample_factor = NULL, hrf, afni_path = NULL, afni_quiet = FALSE) {
  phys_list <- list()
  phys_list$input <- as.data.frame(phys)
  phys_list$detrend <- detrend(phys, detrend_factor) %>% as.data.frame() %>% rename(phys = residual)
  phys_list$upsample <- upsample(phys_list$detrend, upsample_factor) %>% as.data.frame()
  colnames(phys_list$upsample) <- "phys"
  phys_list$deconvolve <- deconvolve_afni(phys_list$upsample, hrf, afni_path, afni_quiet) %>% as.data.frame()
  colnames(phys_list$deconvolve) <- "phys"
  return(phys_list)
}


