calculate_parameter_temporal_derivative_polynomial <- function(in_file, temporal_derivative = 1, polynomial = 2, out_file, overwrite = F) {
  
  # check inputs
  if (!file.exists(in_file)) {
    stop(glue("{in_file} does not exist."))
  }
  
  if (file.exists(out_file) & overwrite == F) {
    stop(glue("{out_file} already exists and overwrite is set to FALSE."))
  }
  
  # read data
  df <- read_table2(in_file, col_names = F)
  
  # calculate temporal derivatives
  df_t <- df
  for (i in 1:temporal_derivative) {
    temp_df_t <- apply(df, 2, function(x) c(rep(0, i), diff(x, lag = i))) %>% as_tibble()
    colnames(temp_df_t) <- colnames(temp_df_t) %>% paste0(., "_td_", i)
    df_t <- cbind(df_t, temp_df_t)
  }
  
  # calculate polynomials
  df_p <- df_t
  for (i in 2:polynomial) {
    temp_df_p <- df_t^i %>% as_tibble()
    colnames(temp_df_p) <- colnames(temp_df_p) %>% paste0(., "_poly_", i)
    df_p <- cbind(df_p, temp_df_p)
  }
  
  # save
  write_csv(df_p, out_path)
    
}