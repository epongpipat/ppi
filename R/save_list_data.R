save_list_data <- function(data, in_file) {
  if (is.list(data)) {
    names <- names(data)
    for (j in 1:length(data)) {
      out_path <- str_replace(in_file, ".csv", paste0("_", names[j], ".csv"))
      write.csv(data[[j]], out_path, row.names = F)
    }
  } else {
    stop("data must be a list")
  }
}
