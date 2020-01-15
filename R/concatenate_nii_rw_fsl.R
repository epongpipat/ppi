concatenate_nii_rw_fsl <- function(nii_list, tr, fsl_path = NULL) {

  if (is.null(fsl_path)) {
    fsl_path <- fslr::get.fsl()
  }

  fsl_cmd <- glue("fslmerge")

}
