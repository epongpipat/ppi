#' @title deconvolve_afni
#' @concept data_wrangling
#' @param data data to deconvolve
#' @param hrf hemodynamic response function (hrf) to deconvolve data
#' @param afni_path path to afni directory (default: NULL)
#'
#' @return
#' @export
#'
#' @examples
deconvolve_afni <- function(data, hrf, afni_path = NULL, afni_quiet = FALSE) {

  # create temporary data file
  in_file_data <- paste0(tempfile(), ".1D")
  write.table(data, in_file_data, col.names = F, row.names = F)

  # create temporary hrf file
  in_file_hrf <- paste0(tempfile(), ".1D")
  write.table(hrf, in_file_hrf, col.names = F, row.names = F)

  # create temporary out file
  out_file <- paste0(tempfile(), ".1D")

  afni_func <- list()
  afni_func$program <- "3dTfitter"
  afni_func$opt$RHS <- in_file_data
  afni_func$opt$FALTUNG <- paste(in_file_hrf, out_file, "012 -2")
  afni_func$opt$l2lasso <- -6
  afni_cmd <- build_afni_cmd(afni_func, afni_quiet)
  execute_afni_cmd(afni_cmd, afni_path)

  df_deconvolved <- suppressMessages(read_table2(out_file, col_names = FALSE, comment = "#")) %>%
    t() %>%
    as.data.frame()

  colnames(df_deconvolved) <- "data"

  # remove temporary files
  file.remove(in_file_data)
  file.remove(in_file_hrf)
  file.remove(out_file)

  return(df_deconvolved$data)

}
