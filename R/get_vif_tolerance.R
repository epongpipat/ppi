#' @title get_vif_tolerance
#' @concept analysis
#' @param predictors
#'
#' @return
#' @export
#'
#' @examples
get_vif_tolerance <- function(predictors) {
  predictors <- as.data.frame(predictors)
  r_sq <- NULL
  for (i in 1:ncol(predictors)) {
    temp_model <- lm(predictors[,i] ~ as.matrix(predictors[,-i]))
    temp_r_sq <- glance(temp_model)$r.squared
    r_sq <- c(r_sq, temp_r_sq)
  }
  data <- tibble(term = colnames(predictors),
                      r_sq = r_sq) %>%
    rowwise() %>%
    mutate(vif = 1 / (1 - r_sq),
           tolerance = 1 / vif) %>%
    ungroup()
  return(data)
}
