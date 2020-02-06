#' @title model_glm_roi2roi
#' @concept analysis
#' @param target_roi data to predict. can be also be a list or multiple columns if there are more than one target roi
#' @param design_matrix predictors. can be also be list or a 3d array if there are more than one set of predictors
#'
#' @return
#' @export
#' @import dplyr furrr
#' @examples
model_glm_roi2roi <- function(target_roi, design_matrix, formula = NULL) {

  # convert target_roi to list ----
  y <- list()
  if (is.list(target_roi)) {
    y <- target_roi
    for (i in 1:length(y)) {
      colnames(y[[i]]) <- "target_roi"
    }
  } else if (is.matrix(target_roi) || is.data.frame(target_roi) || ncol(as.matrix(design_matrix)) == 1) {
    target_roi <- target_roi %>% as.matrix()
    for (i in 1:ncol(target_roi)) {
      y[[i]] <- target_roi[,i] %>% as.matrix()
      colnames(y[[i]]) <- "target_roi"
    }
  } else {
    stop("target_roi must be an array, 2D, or a list")
  }

  # convert design_matrix to list ----
  X <- list()
  if (is.list(design_matrix) & !is.data.frame(design_matrix)) {
    X <- design_matrix
  } else if ((is.matrix(design_matrix) || is.data.frame(design_matrix)) & length(dim(design_matrix)) == 2) {
    X[[1]] <- design_matrix %>% as.matrix()
  } else if ( length(dim(design_matrix)) == 3 ) {
    for (i in 1:(dim(design_matrix)[3])) {
      X[[i]] <- design_matrix[,,i] %>% as.matrix()
    }
  } else {
    stop("design_matrix must be 2D, 3D, or a list")
  }

  # number of seeds and targets ----
  n_target <- length(y)
  n_seed <- length(X)

  # set up data ----
  data <- tibble(n_target = 1:n_target) %>%
    mutate(n_seed = list(1:n_seed)) %>%
    unnest() %>%
    mutate(n_model = row_number()) %>%
    unnest() %>%
    mutate(y = future_map(n_target, function(x) y[[x]] %>% as.matrix()),
           X = future_map(n_seed, function(x) X[[x]] %>% as.matrix()),
           data = future_map2(y, X, function(y, X) cbind(y, X) %>% as.data.frame()))

  #perform data analysis ----
  if (is.null(formula)) {
    data_analysis <- data %>%
      mutate(model = future_map2(y, X, function(y, X) lm(y ~ X)))
  } else {
    data_analysis <- data %>%
      mutate(model = future_map(data, function(x) lm(as.formula(paste0("target_roi ~ ", formula)), x)))
  }

  # extract useful information ----
  data_extracts <- data_analysis %>%
    mutate(vif_tol = future_map(model, get_vif_tolerance),
           residual = future_map(model, "residuals"),
           residual = future_map(residual, function(x) as.data.frame(x, col.names = "residual")),
           tidy = future_map(model, tidy),
           tidy = future_map2(tidy, X, function(x, y) bootPermBroom::tidy_lm_add_r_squared(x, nrow(y)) %>% as.data.frame()),
           glance = future_map(model, function(x) glance(x) %>% as.data.frame()))

  return(data_extracts)

}
