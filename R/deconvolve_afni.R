deconvolve_afni <- function(data, hrf) {

  # create temporary directory
  temp_dir <- paste0(tempdir(), "/temp_deconvolve_afni/")
  dir.create(temp_dir)

  # create temporary data file
  in_file_data <- paste0(temp_dir, "/data.1D")
  write.table(data, in_file_data, col.names = F, row.names = F)

  # create temporary hrf file
  in_file_hrf <- paste0(temp_dir, "/hrf.1D")
  write.table(hrf, in_file_hrf, col.names = F, row.names = F)

  out_file <- paste0(temp_dir, "/data_deconvolved.1D")

  afni_path <- get_afni()
  afni_func <- list()
  afni_func$program <- "3dTfitter"
  afni_func$opt$RHS <- in_file_data
  afni_func$opt$FALTUNG <- paste(in_file_hrf, out_file, "012 -2")
  afni_func$opt$l2lasso <- -6

  afni_cmd <- build_afni_cmd(afni_func)
  sys_cmd <- paste0(afni_path, afni_cmd)
  system(sys_cmd)

  df_deconvolved <- suppressMessages(read_table2(out_file, col_names = FALSE, comment = "#")) %>%
    t() %>%
    as.data.frame()

  colnames(df_deconvolved) <- "data"

  # remove temporary files
  unlink(temp_dir, recursive = T)

  return(df_deconvolved$data)
}
