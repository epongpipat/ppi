#' @title create_data_wrangling_report
#'
#' @param data_wrangling data wrangling output
#' @param out_dir output directory (default: NULL) if null, saves to current working directory
#' @param out_prefix output file prefix (default: NULL)
#' @param out_suffix output file suffix (default: NULL)
#' @param quiet suppress message from rmarkdown::render() (default: TRUE)
#'
#'
#' @return
#' @export
#' @import rmarkdown
#' @examples
create_data_wrangling_report <- function(data_wrangling, out_dir = NULL, out_prefix = NULL, out_suffix = NULL, quiet = TRUE) {
  input_file <- system.file("rmd", "report_data_wrangling.Rmd", package = "ppi")
  if (is.null(out_dir)) {
    out_dir <- getwd()
  } else if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = T)
  }
  out_path <- paste0(out_dir, "/", out_prefix, "data_wrangling_report", out_suffix, ".html")
  rmarkdown::render(input = input_file, output_file = out_path, clean = T, params = list(data_wrangling = data_wrangling), quiet = quiet)
}
