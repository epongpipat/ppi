#' @title extract_time_series_rw_fsl
#' @concept data_extraction
#' @param in_nii
#' @param in_mask_nii
#' @param out_path
#' @param statistic
#' @param overwrite
#' @param fsl_path
#'
#' @return
#' @export
#' @import fslr
#' @examples
extract_time_series_rw_fsl <- function(in_nii, in_mask_nii, out_path, statistic = "mean", overwrite = F, fsl_path = NULL) {
  # check input -----
  if (!file.exists(in_nii)) {
    stop(glue("{in_nii} does not exist."))
  }

  if (!file.exists(in_mask_nii)) {
    stop(glue("{in_mask} does not exist."))
  }

  if (file.exists(out_path) & overwrite == F) {
    stop(glue("{out_path} already exists and overwrite is set to FALSE."))
  }

  if (!(statistic %in% c("mean", "eig", "eigenvariate"))) {
    stop(glue("{statistic} must be mean, eig, or eigenvariate."))
  }

  # write and run fsl command -----
  if (is.null(fsl_path)) {
    fsl_path <- fslr::get.fsl()
  }

  if (statistic == "mean") {
    fsl_cmd <- glue("fslmeants -i {in_nii} -m {in_mask_nii} -o {out_path}")
  } else if (statistic %in% c("eig", "eigenvariate")) {
    fsl_cmd <- glue("fslmeants -i {in_nii} -m {in_mask_nii} --eig -o {out_path}")
  }
  cat(fsl_cmd, "\n")

  fsl_full_cmd <- paste0(fsl_path, fsl_cmd)
  system(fsl_full_cmd)
}
