#' @title calculate_parameter_temporal_derivative_polynomial
#' @concept data_wrangling
#' @param data data to have temporal derivatives and polynomial calculated
#' @param temporal_derivative temporal derivative value (default: 1)
#' @param polynomial polynomial value (default: 2)
#'
#' @return
#' @export
#' @import dplyr
#' @examples
#' # to be added
calculate_parameter_temporal_derivative_polynomial <- function(data, temporal_derivative = 1, polynomial = 2) {

  # check parameters
  if (temporal_derivative < 0 || !is.numeric(temporal_derivative)) {
    stop("temporal_derivative must be a an integer equal to or greater than 0")
  }

  if (polynomial <= 0 || !is.numeric(polynomial)) {
    stop("temporal_derivative must be a positive integer greater than 0")
  }

  # calculate temporal derivatives
  df_t <- data
  if (temporal_derivative > 0) {
    for (i in 1:temporal_derivative) {
      temp_df_t <- apply(df_t, 2, function(x) c(rep(0, i), diff(x, lag = i))) %>% as_tibble()
      colnames(temp_df_t) <- colnames(temp_df_t) %>% paste0(., "_td_", i)
      df_t <- cbind(df_t, temp_df_t)
    }
  }

  # calculate polynomials
  df_p <- df_t
  if (polynomial > 1) {
    for (i in 2:polynomial) {
      temp_df_p <- df_t^i %>% as_tibble()
      colnames(temp_df_p) <- colnames(temp_df_p) %>% paste0(., "_poly_", i)
      df_p <- cbind(df_p, temp_df_p)
    }
  }

  return(df_p)

}
