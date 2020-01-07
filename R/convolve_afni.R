convolve_afni <- function(data, hrf, tr, n_volumes, upsample_factor = NULL) {

  library(afnir)
  library(furrr)

  # create temporary working dir
  temp_dir <- paste0(tempdir(), "/temp_convolution_afni/")
  dir.create(temp_dir)

  # create temporary data file
  data <- as.matrix(data)
  in_file_data <- paste0(temp_dir, "/data.1D")
  write.table(data, in_file_data, col.names = F, row.names = F)

  # create temporary hemodynamic response function (HRF) file
  in_file_hrf <- paste0(temp_dir, "/hrf.1D")
  write.table(hrf, in_file_hrf, col.names = F, row.names = F)

  # apply upsample if specified
  if (!is.null(upsample_factor)) {
    tr <- tr / upsample_factor
    n_volumes <- n_volumes * upsample_factor
  }

  out_file <- paste0(temp_dir, "/data_convolved.1D")

  # create afni command
  afni_path <- get_afni()
  afni_func <- list()
  afni_func$program <- "waver"
  afni_func$opt$FILE <- paste(tr, in_file_hrf)
  afni_func$opt$input <- paste0(in_file_data)
  afni_func$opt$numout <- n_volumes
  afni_cmd <- build_afni_cmd(afni_func)

  # create system command
  sys_cmd <- paste0(afni_path, afni_cmd, " > ", out_file)

  # execute system command
  system(sys_cmd)

  # read output
  df_convolved <- read.csv(out_file, header = F, col.names = "data")

  # remove temporary files
  unlink(temp_dir, recursive = T)

  return(df_convolved$data)

}
