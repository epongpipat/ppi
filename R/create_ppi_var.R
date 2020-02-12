#' @title create_ppi_var
#' @description creates data for each step of the ppi variable by wrapping the functions: \code{convolve_afni()} and \code{downsample()}
#' @concept data_wrangling_wrapper_functions
#' @param psy_var psychological variable data (e.g., psy var that is contrast-coded and upsampled)
#' @param phys_var physiological variable data (e.g., psy var that is detrended and upsampled)
#' @param hrf hemodynamic response function (hrf) time series data
#' @param tr repetition time (tr) in seconds
#' @param n_volumes number of volumes or time points
#' @param upsample_factor factor to upsample data by for convolution and deconvolution step (default: NULL)
#' @param deconvolve option to perform or not perform deconvolution step (default: TRUE)
#' @param afni_path path to afni directory (default: NULL)
#' @return a list of datasets for each data wrangling step of the ppi variables
#' @export
#'
#' @examples
create_ppi_var <- function(psy_var, phys_var, hrf, tr, n_volumes, upsample_factor = NULL, deconvolve = TRUE, afni_path = NULL, afni_quiet = FALSE) {
  ppi_list <- list()

  # ensure that rows of the psy and phys var match
  if (ncol(psy_var) != ncol(phys_var)) {
    stop(paste0("The number of rows in the psy_var (", ncol(psy_var), ") and phys_var (", ncol(phys_var), ") do not match."))
  }

  # ensure rows match the expected time points
  if (is.null(upsample_factor)) {
    expected_time_points <- n_volumes
  } else {
    expected_time_points <- n_volumes * upsample_factor
  }

  if (ncol(psy_var) != expected_time_points) {
    stop(paste0("The rows of both variables (", ncol(psy_var), ") do not match the expected number of time points (", expected_time_points,")."))
  }

  ppi_list$interaction <- apply(as.matrix(psy_var), 2, function(x) x * as.matrix(phys_var)) %>% as.data.frame()
  colnames(ppi_list$interaction) <- str_replace(colnames(ppi_list$interaction), "psy_", "ppi_")
  if (deconvolve == TRUE) {
    ppi_list$convolve <- apply(ppi_list$interaction, 2, function(x) convolve_afni(x, hrf, tr, n_volumes, upsample_factor, afni_path, afni_quiet = afni_quiet)) %>% as.data.frame()
    ppi_list$downsample <- apply(ppi_list$convolve, 2, function(x) downsample(x, upsample_factor)) %>% as.data.frame()
  } else if (deconvolve == FALSE) {
    ppi_list$downsample <- apply(ppi_list$interaction, 2, function(x) downsample(x, upsample_factor)) %>% as.data.frame()
  }

  return(ppi_list)
}
