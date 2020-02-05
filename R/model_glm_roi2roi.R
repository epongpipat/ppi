#' @title model_glm_roi2roi
#' @concept analysis
#' @param target_roi data to predict. can be also be a list or multiple columns if there are more than one target roi
#' @param design_matrix predictors. can be also be list or a 3d array if there are more than one set of predictors
#'
#' @return
#' @export
#' @import dplyr furrr
#' @examples
model_glm_roi2roi <- function(target_roi, design_matrix) {

  y <- as.matrix(target_roi)
  n_target <- ncol(target_roi)

  design_matrix <- X

  if (is.matrix(design_matrix) & length(dim(design_matrix)) == 2) {
    design_matrix_3d <- array(NA, c(dim(design_matrix), 1))
    design_matrix_3d[,,1] <- as.matrix(design_matrix)
  } else if (is.list(design_matrix)) {
    dim_3d <- c(dim(design_matrix[[1]]), length(design_matrix))
    design_matrix_3d <- array(NA, dim_3d)
    for (i in 1:length(design_matrix)) {
      design_matrix_3d[,,i] <- as.matrix(design_matrix[[i]])
    }

  } else if (length(design_matrix) == 3) {
    design_matrix_3d <- design_matrix
  } else {
    stop("design matrix input must be 2D, 3D, or a list")
  }

  n_seed <- dim(design_matrix_3d)[3]

  # set up data ----
  data <- tibble(n_target = 1:n_target) %>%
    mutate(n_seed = list(1:n_seed)) %>%
    unnest() %>%
    mutate(n_model = row_number()) %>%
    unnest() %>%
    mutate(y = future_map(n_target, function(x) as.matrix(target_roi[, x])),
           X = future_map(n_seed, function(x) as.matrix(design_matrix_3d[,,x])))

  # perform data analysis ----
  # and obtain useful statistics
  data_analysis <- data %>%
    mutate(model = future_map2(y, X, function(y, X) lm(y ~ X)),
           vif_tol = future_map(X, get_vif_tolerance),
           residual = future_map(model, "residuals"),
           residual = future_map(residual, as.data.frame),
           tidy = future_map(model, tidy),
           tidy = future_map2(tidy, X, function(x, y) bootPermBroom::tidy_lm_add_r_squared(x, nrow(y)) %>% as.data.frame()),
           glance = future_map(model, function(x) glance(x) %>% as.data.frame()))

  return(data_analysis)

}
