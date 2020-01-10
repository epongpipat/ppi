#' @title create_ppi_var
#'
#' @param psy_var psychological variables (e.g., contrast-coded and upsampled)
#' @param phys_var physiological variables (e.g., detrended and upsampled)
#' @param hrf hemodynamic response function (hrf) time series data
#' @param tr retrieval time (tr) in seconds
#' @param n_volumes number of volumes or time points
#' @param upsample_factor factor to upsample data by for convolution and deconvolution step
#' @param deconvolve option to perform or not perform deconvolution step (default: TRUE)
#'
#' @return a list of datasets for each data wrangling step of the ppi variables
#' @export
#'
#' @examples
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
