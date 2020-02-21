#' @title save_data_wrangling
#'
#' @param data_wrangling data wrangling output
#' @param out_dir output directory
#' @param out_prefix output file prefix
#' @param out_suffix output file suffix
#'
#' @return
#' @export
#'
#' @examples
save_data_wrangling <- function(data_wrangling, out_dir, out_prefix, out_suffix) {
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = T)
  }
  out_path <- paste0(out_dir, out_prefix, "data_wrangling", out_suffix)
  saveRDS(data_wrangling, paste0(out_path, ".rds"))
  params_json <- jsonlite::toJSON(data_wrangling, pretty = T, dataframe = 'columns')
  write(params_json, paste0(out_path, ".json"))
}
