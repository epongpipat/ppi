extract_time_series_mean <- function(in_nii, in_mask_nii, out_path, overwrite = F) {

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

  # load packages -----
  require("xfun")
  packages <- c("oro.nifti")
  xfun::pkg_attach(packages, message = F, install = T)

  df_file <- oro.nifti::readNIfTI(in_nii)
  df_mask <- oro.nifti::readNIfTI(in_mask_nii)

  bold_mean <- NULL
  for (i in 1:dim(df_file)[4]) {
    df_vol <- df_file[,,,i]
    temp_bold_voxels <- df_vol[df_mask@.Data == 1]
    temp_bold_voxels_thr <- temp_bold_voxels[temp_bold_voxels > 0]

    # calculate mean
    temp_bold_mean <- mean(temp_bold_voxels_thr)
    bold_mean <- c(bold_mean, temp_bold_mean)
  }

  bold_mean <- tibble(bold_mean)

  write_csv(bold_mean, out_path, col_names = F)
}
