#' @title extract_time_series_mean
#' @concept data_extraction
#' @param data data to extract mean time series from
#' @param mask mask to apply and extract mean time series from. mask can also be a 4D array with a different regions of interest in each 4th dimension
#' @param labels labels the correspond to the mask regions of interest (default: NULL)
#'
#' @return data.frame of time/volume (row) by region
#' @export
#' @import dplyr
#' @examples
extract_time_series_mean <- function(data, mask, labels = NULL) {

  if (length(dim(mask)) == 4) {
    data_ts <- apply(data, 4, function(x) apply(mask, 4, function(y) x[y > 0] %>% .[. > 0] %>% mean())) %>% t() %>% as.data.frame()
  } else {
    data_ts <- apply(data, 4, function(x) x[mask > 0] %>% .[. > 0] %>% mean()) %>% as.data.frame()
  }

  if (!is.null(labels)) {
    colnames(data_ts) <- labels
  } else {
    colnames(data_ts) <- paste0("roi_", 1:ncol(data_ts))
  }

  return(data_ts)

}
