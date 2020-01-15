#' @title save_list_data
#' @concept helper
#' @param data list data to save
#' @param out_dir directory to save list data
#' @param out_prefix prefix of files to save (default: NULL)
#' @export
#'
save_list_data <- function(data, out_dir, out_prefix = NULL) {

  if (!is.list(data)) {
    stop("data must be a list")
  }

  names <- names(data)

  if (!is.null(out_prefix)) {
    out_dir <- paste0(out_dir, out_prefix)
  }

  for (j in 1:length(data)) {
    out_path <- paste0(out_dir, names[j], ".csv")
    write.csv(data[[j]], out_path, row.names = F)
  }
}
