save_list_data_fig <- function(data, in_file) {
  if (is.list(data)) {
    names <- names(data)
    for (j in 1:length(data)) {
      out_path <- str_replace(in_file, ".csv", paste0("_", names[j], ".png"))
      fig <- create_ts_fig(data[[j]], title = names[j])
      ggsave(out_path, fig, width = 6, height = 2 * ncol(data[[j]]), units = "in")
    }
  } else {
    stop("data must be a list")
  }
}
