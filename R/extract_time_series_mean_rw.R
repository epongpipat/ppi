#' @title extract_time_series_mean_rw
#' @concept data_extraction
#' @param in_path_data path to nifti data for time series extraction
#' @param in_path_mask path to nifti mask applied to data for time series extraction (mask can be a 4D nifti file with a different region of interest in each 4th dimension)
#' @param in_path_labels path to labels .csv file with a single column of labels with no header (default: NULL)
#' @param out_path path to output .csv file of time/volume (rows) by regions of interest (column)
#' @param overwrite option to overwrite out_path file (default: FALSE)
#'
#' @return
#' @export
#' @import dplyr RNifti readr
#' @examples
extract_time_series_mean_rw <- function(in_path_data, in_path_mask, in_path_labels = NULL, out_path, overwrite = FALSE) {

  # check input -----
  if (!file.exists(in_path_data)) {
    stop(glue("{in_path_data} does not exist."))
  }

  if (!file.exists(in_path_mask)) {
    stop(glue("{in_path_mask} does not exist."))
  }

  if (!is.null(in_path_labels)) {
    if (!file.exists(in_path_labels)) {
      stop(glue("{in_path_labels} does not exist."))
    }
  }

  if (file.exists(out_path) & overwrite == F) {
    stop(glue("{out_path} already exists and overwrite is set to FALSE."))
  }

  out_dir <- dirname(out_path)
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = T)
  }

  df_data <- readNifti(in_path_data)
  df_mask <- readNifti(in_path_mask)
  df_labels <- read_csv(in_path_labels, col_names = F) %>% unlist() %>% as.character()
  df_ts <- extract_time_series_mean(df_data, df_mask, labels = df_labels)
  write_csv(df_ts, out_path, col_names = F)

}
