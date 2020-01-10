#' @title convolve_afni
#' @concept data_wrangling
#' @param data data to convolve
#' @param hrf hemodynamic response function (hrf) time series
#' @param tr repition time (tr) in seconds
#' @param n_volumes number of volumes or time points
#' @param upsample_factor factor to upsample data for convolution step
#'
#' @return
#' @export
#' @import afnir furrr
#' @examples
convolve_afni <- function(data, hrf, tr, n_volumes, upsample_factor = NULL, afni_path = NULL) {

  # create temporary data file
  data <- as.matrix(data)
  in_file_data <- paste0(tempfile(), ".1D")
  write.table(data, in_file_data, col.names = F, row.names = F)

  # create temporary hemodynamic response function (HRF) file
  in_file_hrf <- paste0(tempfile(), ".1D")
  write.table(hrf, in_file_hrf, col.names = F, row.names = F)

  # apply upsample if specified
  if (!is.null(upsample_factor)) {
    tr <- tr / upsample_factor
    n_volumes <- n_volumes * upsample_factor
  }

  out_file <- paste0(tempfile(), ".1D")

  # create afni command
  afni_func <- list()
  afni_func$program <- "waver"
  afni_func$opt$FILE <- paste(tr, in_file_hrf)
  afni_func$opt$input <- paste0(in_file_data)
  afni_func$opt$numout <- n_volumes
  afni_cmd <- build_afni_cmd(afni_func)
  sys_cmd <- paste0(afni_cmd, " > ", out_file)
  execute_afni_cmd(afni_cmd, afni_path)

  # read output
  df_convolved <- read.csv(out_file, header = F, col.names = "data")

  # remove temporary files
  file.remove(in_file_data)
  file.remove(in_file_hrf)
  file.remove(out_file)

  return(df_convolved$data)

}
