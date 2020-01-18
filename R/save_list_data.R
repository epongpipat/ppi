#' @title save_list_data
#' @concept helper
#' @param data list data to save
#' @param out_dir directory to save list data
#' @param out_prefix prefix of files to save (default: NULL)
#' @param out_suffix suffix of files to save (default: NULL)
#' @return
#' @export
#' @examples
save_list_data <- function(data, out_dir, out_prefix = NULL, out_suffix = NULL, col_names = TRUE) {

  if (!is.list(data)) {
    stop("data must be a list")
  }

  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = T)
  }

  names <- names(data)

  if (!is.null(out_prefix)) {
    out_dir <- paste0(out_dir, out_prefix)
  }

  for (j in 1:length(data)) {


    if (!is.null(out_suffix)) {
      out_ending <- paste0(out_suffix, ".csv")
    } else {
      out_ending <- ".csv"
    }

    out_path <- paste0(out_dir, names[j], out_ending)

    if (col_names == T) {
      write.csv(data[[j]], out_path, row.names = FALSE)
    } else {
      write.csv(data[[j]], out_path, row.names = TRUE)
    }

  }
}
