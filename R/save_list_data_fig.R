#' @title save_list_data_fig
#' @concept helper
#' @param data list data to create and save time series figure
#' @param out_dir directory to save figures
#' @param out_prefix prefix of figures to save (default: NULL)
#' @param out_suffix suffix of figures to save (default: NULL)
#' @return
#' @export
#'
#' @examples
save_list_data_fig <- function(data, out_dir, out_prefix = NULL, out_suffix = NULL) {

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

    fig <- create_ts_fig(data[[j]], title = names[j])
    ggsave(out_path, fig, width = 6, height = 2 * ncol(data[[j]]), units = "in")

  }

}
