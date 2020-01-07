get_hrf_afni <- function(hrf, tr, upsample_factor = NULL) {

  library(dplyr)
  library(afnir)
  library(glue)

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

  # get afni path ----
  afni_path <- get_afni()

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

  afni_cmd <- build_afni_cmd(afni_func)

  # full command ----
  sys_cmd <- paste0(afni_path, afni_cmd)

  # execute command ----
  system(sys_cmd)

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

#hrf <- "spmg1"
#out_file <- glue("~/Box/my_mri/behavioral/hrf_{hrf}_up_16.csv")
#df <- get_hrf_afni(hrf, 1.5, upsample_factor = 16, out_file = out_file)
