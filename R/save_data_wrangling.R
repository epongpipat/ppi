save_data_wrangling <- function(data_wrangling, out_dir, out_prefix, out_suffix) {
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = T, mode = "0007")
  }
  out_path <- paste0(out_dir, out_prefix, "data_wrangling", out_suffix)
  saveRDS(data_wrangling, paste0(out_path, ".rds"))
  params_json <- jsonlite::toJSON(data_wrangling, pretty = T, dataframe = 'columns')
  write(params_json, paste0(out_path, ".json"))
}
