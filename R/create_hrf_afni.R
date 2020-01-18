#' @title create_hrf_afni
#' @concept data_wrangling
#' @param hrf name of the hemodynamic response function. can be gam, block or spmg1
#' @param tr retrieval time (tr) in seconds
#' @param upsample_factor number of volumes or time points
#'
#' @return
#' @export
#' @import dplyr afnir glue
#'
#' @examples
#' hrf <- create_hrf_afni("spmg1", 1.5, 16)
#' head(hrf)
#'
#' # visualize
#' create_ts_fig(hrf, "SPMG1")
create_hrf_afni <- function(hrf, tr, upsample_factor = NULL, afni_path = NULL, afni_quiet = TRUE) {

  df_hrf <- tribble(~hrf_name, ~hrf_duration,
                    "gam", 12,
                    "block", 15,
                    "spmg1", 25)

  n_volumes <- df_hrf %>%
    filter(hrf_name == hrf) %>%
    select(hrf_duration) %>%
    as.numeric()

  if (!is.null(upsample_factor)) {
    n_volumes <- n_volumes * upsample_factor
    tr <- tr / upsample_factor
  }

  # build afni cmd list ----
  afni_func <- list()
  afni_func$program <- "3dDeconvolve"
  afni_func$opt <- list()
  afni_func$opt$nodata <- glue("{n_volumes} {tr}")
  afni_func$opt$polort <- -1
  afni_func$opt$num_stimts <- 1

  if (hrf %in% c("gam", "spmg1")) {
    afni_func$opt$stim_times <- glue("1 1D:0 {toupper(hrf)}")
  } else if (hrf == "block") {
    afni_func$opt$stim_times <- glue('1 1D:0 "{toupper(hrf)}(0.1,1)"')
  } else {
    stop("hrf (", hrf, ") must be either block, gam, spmg1")
  }

  out_file <- tempfile()
  afni_func$opt$x1D <- out_file
  afni_func$opt$x1D_stop <- ""

  afni_cmd <- build_afni_cmd(afni_func, afni_quiet)
  execute_afni_cmd(afni_cmd, afni_path)

  # rename to defined out_file ----
  afni_out_file <- paste0(out_file, ".xmat.1D")
  file.rename(afni_out_file, out_file)

  # load output ----
  df <- read.csv(out_file, comment.char = "#", header = F, col.names = "hrf")

  if (hrf == "spmg1") {
    df$hrf <- scale_min_max(df$hrf, min = 0)
  }

  file.remove(out_file)

  return(df)

}
