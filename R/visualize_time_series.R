#' @title visualize_time_series
#' @concept visualization
#' @param data data to create time series figure
#' @param title title of figure (default: NULL)
#'
#' @return time series figure with volume on the x-axis and value on the y-axis
#' @export
#' @import ggplot2 dplyr stringr tidyr
#' @examples
visualize_time_series <- function(data, title = NULL, scales = NULL, nrow = NULL, ncol = NULL) {
  if (ncol(data) == 1) {
    colnames(data) <- "value"
    fig <- data %>%
      mutate(volume = row_number()) %>%
      ggplot(., aes(volume, value)) +
      geom_line()
  } else {
    colnames(data) <- paste(str_pad(1:ncol(data), nchar(ncol(data)), "left", 0), "_", colnames(data))
    fig <- data %>%
      mutate(volume = row_number()) %>%
      gather(., "variable", "value", -volume) %>%
      ggplot(., aes(volume, value)) +
      geom_line() +
      facet_wrap(~ variable, scales = scales, nrow = nrow, ncol = ncol)
  }

  fig <- fig +
    theme_minimal() +
    labs(title = title)

  return(fig)
}

