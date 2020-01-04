calculate_mean_func <- function(in_file, out_file) {
  packages <- c("dplyr", "stringr")
  xfun::pkg_attach(packages, install = T, message = F)
  
  in_file <- "~/Box/my_mri/DJ_r01.nii.gz"
  out_file <- "~/Box/my_mri/dj_r01_mean.nii.gz" %>% 
    str_remove_all(., ".nii.gz")
  
  df <- oro.nifti::readNIfTI(in_file)
  df_mean <- df
  for (i in 1:dim(df@.Data)[1]) {
    for (j in 1:dim(df@.Data)[2]) {
      for (k in 1:dim(df@.Data)[3]) {
        ts <- df@.Data[i,j,k,]
        ts <- ts[ts > 0]
        df_mean@.Data[i,j,k,1] <- mean(ts)
      }
    }
  }
  writeNIfTI(df_mean, out_file)
}