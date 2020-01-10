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
deconvolve_afni <- function(data, hrf, afni_path = NULL) {

  # create temporary directory
  # temp_dir <- paste0(tempdir(), "/temp_deconvolve_afni/")
  # dir.create(temp_dir)

  # create temporary data file
  in_file_data <- tempfile()
  write.table(data, in_file_data, col.names = F, row.names = F)

  # create temporary hrf file
  in_file_hrf <- tempfile()
  write.table(hrf, in_file_hrf, col.names = F, row.names = F)

  out_file <- tempfile()

  afni_func <- list()
  afni_func$program <- "3dTfitter"
  afni_func$opt$RHS <- in_file_data
  afni_func$opt$FALTUNG <- paste(in_file_hrf, out_file, "012 -2")
  afni_func$opt$l2lasso <- -6
  afni_cmd <- build_afni_cmd(afni_func)
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
