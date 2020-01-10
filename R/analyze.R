analyze <- function(in_nii, design_matrix) {

  y_all <- RNifti::readNifti(in_nii)
  x <- design_matrix
  for (i in 1:dim(y)[1]) {
    for (j in 1:dim(y)[2]) {
      for (k in 1:dim(y)[3]) {
        y <- NA
        y <- y[i,j,k,]
        model <- lm(y ~ x)
        tidy <- tidy(model)
        estimate <- tidy$estimate
        standard_error <- tidy$std.error
        t_value <- tidy$statistic
        p_value <- tidy$p.value
        residual <- model$residuals
      }
    }
  }
}
