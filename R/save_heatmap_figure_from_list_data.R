#' @title save_heatmap_figure_from_list_data
#' @concept helper
#' @param data list data to create and save time series figure
#' @param out_dir directory to save figures
#' @param out_prefix prefix of figures to save (default: NULL)
#' @param out_suffix suffix of figures to save (default: NULL)
#' @return
#' @export
#'
#' @examples
save_heatmap_figure_from_list_data <- function(data, out_dir, out_prefix = NULL, out_suffix = NULL, transpose = FALSE, width = NA, height = NA, units = "in") {

  if (!is.list(data)) {
    stop("data must be a list")
  }

  names <- names(data)

  if (!is.null(out_prefix)) {
    out_dir <- paste0(out_dir, out_prefix)
  }

  names <- names(data)
  for (j in 1:length(data)) {

    if (!is.null(out_suffix)) {
      out_ending <- paste0(out_suffix, ".png")
    } else {
      out_ending <- ".png"
    }

    fig <- visualize_time_series_heatmap(data[[j]], title = names[j], transpose = transpose)

    out_path <- paste0(out_dir, names[j], out_ending)
    ggsave(out_path, fig, width = width, height = height, units = units)

  }

}
