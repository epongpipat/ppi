#' @title create_time_series_heatmap_figure
#' @concept visualization
#' @param data data of volume/time points (row) by region of interest (column) for heatmap figure
#' @param title title of figure (default: NULL)
#' @return heatmap of volume by region of interest
#' @export
#'
#' @examples
create_time_series_heatmap_figure <- function(data, title = NULL, transpose = FALSE) {
  colnames(data) <- 1:ncol(data)
  data <- apply(data, 2, scale) %>%
    as.data.frame()
  data_long <- data %>%
    mutate(vol = row_number()) %>%
    gather(., "phys", "value", -vol) %>%
    mutate(phys = as.numeric(phys))
  max_value <- max(abs(data_long$value))
  fig <- ggplot(data_long, aes(vol, phys, fill = value)) +
    geom_raster() +
    theme_minimal() +
    scale_fill_distiller(palette = "RdBu", direction = -1, limits = c(-max_value, max_value)) +
    scale_x_continuous(breaks = seq(0, nrow(data), 50)) +
    scale_y_continuous(breaks = seq(0, nrow(data), 50)) +
    labs(title = title,
         x = "Volume",
         y = "ROI",
         fill = NULL,
         caption = "Note: Time series has been z-scored for each ROI")

  if (transpose == TRUE) {
    fig <- fig +
      coord_flip()
  }

  return(fig)
}
