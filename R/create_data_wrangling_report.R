#' @title create_data_wrangling_report
#'
#' @param data_wrangling data wrangling output
#' @param out_dir output directory
#' @param out_prefix output file prefix
#' @param out_suffix output file suffix
#' @param quiet suppress message from rmarkdown::render()
#'
#'
#' @return
#' @export
#' @import rmarkdown
#' @examples
create_data_wrangling_report <- function(data_wrangling, out_dir, out_prefix, out_suffix, quiet = T) {
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = T)
  }
  out_path <- paste0(out_dir, out_prefix, "data_wrangling_report", out_suffix, ".html")
  rmarkdown::render(system.file("rmd", "report_data_wrangling.Rmd", package = "ppi"), output_file = out_path, clean = T, params = list(data_wrangling = data_wrangling), quiet = quiet)
}
