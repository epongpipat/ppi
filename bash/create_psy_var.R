#!/usr/bin/env Rscript --vanilla
library(optparse)

option_list <- list(
  make_option(c("-e", "--events"),
              type="character",
              help="path to events file. Events file needs to be in 3-column bids format and must contain onset, duration, and trial_type columns.",
              metavar="character"),
  make_option(c("-e", "--contrast", "--contrast_table"),
              type="character",
              help="path to contrast table file. The contrast table file must 1.) contain no row names, but represent the levels of the factor or categorical variable and 2.) contain columns representing the contrast code with column names",
              metavar="character"),
  make_option(c("--hrf"),
              type="numeric",
              help="path to hemodynamic response function",
              metavar="numeric"),
  make_option(c("--tr"),
              type="numeric",
              help="retrieval time (TR) in seconds",
              metavar="numeric"),
  make_option(c("-t", "--n_volumes"),
              type="numeric",
              help="number of volumes or time points",
              metavar="numeric"),
  make_option(c("--upsample", "--upsample_factor"),
              default = NULL,
              help="upsample factor for deconvolution step",
              metavar="numeric"),
  make_option(c("-o", "--out"),
              type="character",
              default=NULL,
              help="output directory (default: same directory as events file)",
              metavar="character")
)

opt_parser <- OptionParser(option_list = option_list);
opt <- parse_args(opt_parser);

psy_var <- create_psy_var(events, contrast_table, hrf, tr, n_volumes, upsample_factor = NULL)


option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL,
              help="dataset file name", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out.txt",
              help="output file name [default= %default]", metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
