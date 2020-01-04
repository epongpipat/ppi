analyze_glm_fsl <- function(in_nii, in_design_matrix, out_file_prefix, out_t = TRUE, out_p = TRUE, out_res = TRUE) {

  fsl_path <- fslr::get.fsl()

  in_nii <- "test.nii.gz"
  in_design_matrix <- "path.csv"
  out_file_prefix <- "first_level_"
  out_t <- T
  out_p <- T
  out_res <- T

  out_file_b <- paste0(out_file_prefix, "b")
  out_file_cmd <- paste0(" -o ", out_file_b)

  if (out_t == TRUE) {
    out_file_t <- paste0(out_file_prefix, "t_value.nii.gz")
    out_file_cmd <- paste0(out_file_cmd, " --out_t ", out_file_t)
  }

  if (out_p == TRUE) {
    out_file_p <- paste0(out_file_prefix, "p_value.nii.gz")
    out_file_cmd <- paste0(out_file_cmd, " --out_p ", out_file_p)
  }

  if (out_res == TRUE) {
    out_file_res <- paste0(out_file_prefix, "residual")
    out_file_cmd <- paste0(out_file_cmd, " --out_res ", out_file_res)
  }

  fsl_cmd <- paste0("fsl_glm -i ", in_nii, " -d ", in_design_matrix, out_file_cmd)
  full_cmd <- paste0(fsl_path, fsl_cmd)
  cat("Running the command:\n", full_cmd)
  system(full_cmd)

}
