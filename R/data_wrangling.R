#' @title data_wrangling
#' @description uber data wrangling wrapper function to create data for each step of data wrangling for each psy, phys, and ppi variables to ultimately create the design matrix. This function is a wrapper of \code{create_hrf_afni()}, \code{create_psy_var()}, \code{create_phys_var()}, \code{create_ppi_var()}, and \code{create_design_matrix()}
#' @concept data_wrangling_uber_functions
#' @param psy_events_data events data with columns of onset, duration, and trial_type
#' @param psy_contrast_table contrast code
#' @param phys_data time series data of physiological variable (seed ROI)
#' @param detrend_factor factor to detrend time series
#' @param hrf_name name of hemodynamic response function (hrf) to use during convolution and deconvolution step
#' @param tr repition time (tr) in seconds
#' @param n_volumes number of volumes or time points
#' @param upsample_factor factor to upsample psy and phys data for convolution and deconvolution step (default: NULL)
#' @param deconvolve perform deconvolution of phys and convolve of ppi term (also known as deconvolve-convolve or reconvolve step) (default: TRUE)
#' @param nuisance_var data of nuisance variables to include in design matrix
#' @param afni_path path to afni directory (default: NULL)
#' @return
#' @export
#'
#' @examples
#' # to be added
data_wrangling <- function(psy_events_data,
                           psy_unlabeled_trial_type,
                           psy_contrast_table,
                           phys_data,
                           detrend_factor,
                           hrf_name,
                           tr,
                           n_volumes,
                           upsample_factor = NULL,
                           deconvolve = TRUE,
                           nuisance_var = NULL,
                           afni_path = NULL) {

  # # mri parameters
  # tr <- 3
  # n_volumes <- 105
  #
  # psy_events <- readr::read_tsv(url("https://openneuro.org/crn/datasets/ds000171/snapshots/00001/files/sub-control01:func:sub-control01_task-music_run-1_events.tsv")) %>%
  #   mutate(trial_type = as.factor(trial_type))
  #
  # psy_contrast_table <- cbind(stimulus_vs_response = c(1, 1, -3, 1)/4,
  #                             music_vs_tones = c(1, 1, 0, -2)/3,
  #                             positive_music_vs_negative_music = c(-1, 1, 0, 0)/2)
  #
  # # for this example, we will choose SPM's default canonical hrf and upsample factor of 16
  # upsample_factor <- 16
  # hrf <- create_hrf_afni("spmg1", tr, upsample_factor)
  #
  # phys_left_parietal <- "~/Desktop/sub-control01_task-music_run-1_bold_space-subj_vox-32-24-38.csv"
  #
  # phys_data <- read_csv(phys_left_parietal, col_names = "seed")
  # afni_path <- NULL
  # psy_unlabeled_trial_type <- "response"

  data_wrangling <- list()
  data_wrangling$hrf <- create_hrf_afni(hrf_name, tr, upsample_factor)
  data_wrangling$psy_var <- create_psy_var(psy_events_data, psy_contrast_table,
                                           data_wrangling$hrf, tr, n_volumes,
                                           upsample_factor, psy_unlabeled_trial_type, afni_path)
  data_wrangling$phys_var <- create_phys_var(phys_data, detrend_factor,
                                             upsample_factor, data_wrangling$hrf, afni_path)

  if (deconvolve == TRUE) {
    data_wrangling$ppi_var <- create_ppi_var(data_wrangling$psy_var$upsample,
                                             data_wrangling$phys_var$deconvolve,
                                             data_wrangling$hrf, tr, n_volumes,
                                             upsample_factor, deconvolve, afni_path)
  } else if (deconvolve == FALSE) {
    data_wrangling$ppi_var <- create_ppi_var(data_wrangling$psy_var$upsample,
                                             data_wrangling$phys_var$upsample,
                                             data_wrangling$hrf, tr, n_volumes,
                                             upsample_factor, deconvolve, afni_path)
  }

  data_wrangling$design_matrix <- create_design_matrix(data_wrangling$psy_var$downsample,
                                                       data_wrangling$phys_var$detrend,
                                                       data_wrangling$ppi_var$downsample,
                                                       nuisance_var)

  return(data_wrangling)
}
