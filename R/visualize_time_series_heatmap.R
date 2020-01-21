#' @title visualize_time_series_heatmap
#' @concept visualization
#' @param data data of volume/time points (row) by variable (e.g., multiple regions of interest or predictors of design matrix) for heatmap figure
#' @param title title of figure (default: NULL)
#' @return heatmap of volume by variable
#' @export
#' @import ggplot2 dplyr
#' @examples
visualize_time_series_heatmap <- function(data,
                                          scale_data = FALSE,
                                          title = NULL,
                                          caption = NULL,
                                          reverse_volume_axis = FALSE,
                                          variable_axis_label = "variable",
                                          numeric_variable_names = FALSE,
                                          palette = "RdBu",
                                          palette_direction = 1,
                                          transpose = FALSE) {

  if (numeric_variable_names == F) {
    colnames(data) <- paste0(str_pad(1:ncol(data), nchar(ncol(data)), "left", 0), "_", colnames(data))
  } else if (numeric_variable_names == T) {
    colnames(data) <- 1:ncol(data)
  } else {
    stop("numeric_variable_names must be either TRUE or FALSE")
  }

  if (scale_data == FALSE) {
    # do nothing
  } else if (scale_data == "z-score") {
    data <- apply(data, 2, scale)
  } else if (scale_data == "min-max") {
    data <- apply(data, 2, scale_min_max)
  } else {
    stop("scale_data must be either FALSE, z-score, or min-max")
  }

  data <- data %>%
    as.data.frame()

  data_long <- data %>%
    mutate(volume = row_number()) %>%
    gather(., "variable", "value", -volume)

  if (numeric_variable_names == T) {
    data_long <- data_long %>%
      mutate(variable = as.numeric(variable))
  }

  max_value <- max(abs(data_long$value))

  fig <- ggplot(data_long, aes(volume, variable, fill = value)) +
    geom_raster() +
    theme_minimal() +
    labs(title = title,
         x = variable_axis_label,
         fill = NULL,
         caption = caption) +
    theme(axis.text.y = element_text(hjust = 1, angle = 45),
          panel.grid.minor = element_line(linetype = "dotted"))

  if (scale_data != "min-max") {
    fig <- fig +
      scale_fill_distiller(palette = palette, direction = palette_direction, limits = c(-max_value, max_value))
  } else {
    fig <- fig +
      scale_fill_distiller(palette = palette, direction = palette_direction)
  }

  if (transpose == TRUE) {
    fig <- fig +
      coord_flip() +
      labs(x = "volume",
           y = variable_axis_label) +
      theme(axis.text.y = NULL,
            axis.text.x = element_text(hjust = 1, angle = 45))
  }

  if (reverse_volume_axis == TRUE) {
    fig <- fig +
      scale_x_reverse()
  }

  return(fig)
}
