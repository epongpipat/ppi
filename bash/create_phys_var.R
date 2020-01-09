#!/usr/bin/env Rscript --vanilla
packages <- c("optparse", "dplyr", "stringr", "afnir")
xfun::pkg_attach(packages, message = F, install = T)

script_dir <- "~/Documents/GitHub/ppi/R/"
script_files <- list.files(script_dir)
script_path <- paste0(script_dir, script_files)
script_ppi <- lapply(script_path, source)

option_list <- list(
  make_option(c("-i", "--in_file"),
              type="character",
              help="path to physiological time series file. A vertical array of numbers with no column name",
              metavar="character"),
  make_option(c("--detrend"),
              type="double",
              help="factor to temporally detrend the time series",
              metavar="double"),
  make_option(c("--upsample"),
              type="double",
              help="factor to upsample time series for deconvolution step (default: NULL)",
              metavar="double"),
  make_option(c("--hrf"),
              type="character",
              help="path to hemodynamic response function",
              metavar="character"),
  make_option(c("-o", "--out_dir"),
              type="character",
              help="output directory (default: same directory as events file)",
              metavar="character")
)

opt_parser <- OptionParser(option_list = option_list);
opt <- parse_args(opt_parser);

if (is.null(opt$in_file)) {
  stop("--in_file option must be specified")
}

if (is.null(opt$detrend)) {
  stop("--detrend option must be specified")
}

if (is.null(opt$hrf)) {
  stop("--hrf option must be specified")
}

phys <- read.csv(opt$in_file, header = F, col.names = "phys")
hrf <- read.csv(opt$hrf, header = F, col.names = "hrf")

phys_var <- create_phys_var(phys, opt$detrend, opt$upsample, hrf)
phys_var_names <- names(phys_var)

for (i in 1:length(phys_var)) {
  temp_name <- phys_var_names[i]
  temp_df <- phys_var[[i]]
  temp_out_path <- str_replace(opt$in_file, ".csv", paste0("_", temp_name, ".csv"))
  write.table(temp_df, temp_out_path, row.names = F)
}
