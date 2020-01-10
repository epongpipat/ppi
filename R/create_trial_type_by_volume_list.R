#' @title create_trial_type_by_volume_list
#' @concept data_wrangling
#' @param events events with columns of onset, duration, and trial_type
#' @param tr repetition time (tr) in seconds
#' @param n_volumes number of volumes or time points
#' @param thr threshold or percentage needed to label volume as trial_type
#' @param unlabeled_trial_type trial_type for volumes without names (default: "fixation")
#'
#' @return data with columns of volume and trial_type
#' @export
#'
#' @examples
#' #' library(dplyr)
#'
#' # this examples uses the following data from openneuro.org
#' # https://openneuro.org/datasets/ds000171/versions/00001
#'
#' # in this dataset, participants listen to either positive music,
#' # negative music, or tones (control). Positive and negative musical stimulus
#' # are presented for 31.5 seconds and tones are presented for 33 seoncds.
#' # After each stimulus, participants have 3 seconds to report their valence
#' # (from very sad to very happy) and arousal (from very passive to very #
#' # active). the repitition time (tr) for this dataset was 3 and the number of
#' # volumes collected for this was run 105.
#'
#' # mri parameters
#' tr <- 3
#' n_volumes <- 105
#'
#' # read events from openneuro.org
#' psy_events <- readr::read_tsv(url("https://openneuro.org/crn/datasets/ds000171/snapshots/00001/files/sub-control01:func:sub-control01_task-music_run-1_events.tsv")) %>%
#'   mutate(trial_type = as.factor(trial_type))
#'
#' # orthogonal contrast code that test:
#' # 1. stimulus vs response
#' # 2. music vs tones
#' # 3. positive music vs negative music
#' psy_contrast_table <- as.data.frame(cbind(stimulus_vs_response = c(1, 1, -3, 1)/4,
#'                                           music_vs_tones = c(1, 1, 0, -2)/3,
#'                                           positive_music_vs_negative_music = c(-1, 1, 0, 0)/2))
#'
#' # for this example, we will choose SPM's default canonical hrf and upsample factor of 16
#' upsample_factor <- 16
#' hrf <- create_hrf_afni("spmg1", tr, upsample_factor)
#'
#' # run function
#' psy_trial_type_by_volume <- create_trial_type_by_volume_list(events = psy_events,
#'                           tr = tr,
#'                           n_volumes = n_volumes,
#'                           unlabeled_trial_type = "response")
#'
#' head(psy_trial_type_by_volume)
#' summary(psy_trial_type_by_volume$trial_type)
#'
#' # references:
#' # Lepping RJ, Atchley RA, Chrysikou E, Martin LE, Clair AA, Ingram RE, et al. Neural processing of emotional musical and nonmusical stimuli in depression.  PlosONE.  In Press.
#' # Lepping RJ, Atchley RA, Savage CR. Development of a Validated Emotionally Provocative Musical Stimulus Set for Research. Psychology of Music. 2015; online before print. doi:10.1177/0305735615604509.
#' # Lepping RJ, Atchley RA, Martin LE, Patrician TM, Stroupe N, Brooks WM, et al. Limbic responses to positive and negative emotionally evocative music: An fMRI study.  Society for Neuroscience annual meeting 2012 Oct 13-18; New Orleans, LA 2012.
#' # Lepping RJ, Atchley RA, Martin LE, Brooks WM, Clair AA, Ingram RE, et al. Musical and nonmusical sounds evoke different patterns of neural activity: An fMRI study.  Psychonomic Society annual meeting; 2012 Nov 14-18; Minneapolis, MN 2012.
#' # Lepping RJ, Atchley RA, Martin LE, Patrician TM, Ingram RE, Clair AA, et al. The effect of musical experiences and musical training on neural responses to emotionally evocative music and non-musical sounds.  Social and Affective Neuroscience Society annual conference 2013 Apr 12-13; San Francisco, CA 2013
#' # Lepping RJ, Atchley RA, Patrician TM, Stroupe NN, Martin LE, Ingram RE, et al. Music to my ears: Neural responsiveness to emotional music and sounds in depression.  Society of Biological Psychiatry annual scientific convention 2013 May 16-18; San Francisco, CA 2013.
create_trial_type_by_volume_list <- function(events, tr, n_volumes, thr = 0.51, unlabeled_trial_type = "fixation") {

  total_fmri_time_sec <- tr * n_volumes

  # task data
  df_behav <- events %>%
    mutate(end = onset + duration)

  # new trial_typedata
  df <- tibble(onset = seq(0, total_fmri_time_sec, tr),
               trial_type = unlabeled_trial_type) %>%
    mutate(volume = row_number(),
           end = lead(onset)) %>%
    na.omit()

  # begin assigning trial_type to each volume
  for (i in 1:nrow(df)) {

    vol_start <- df$onset[i]
    vol_end <- df$end[i]
    temp_trial_type <- NULL

    if (sum(vol_start >= df_behav$onset & vol_end <= df_behav$end) == 1) {
      # 1. within trial_type (both true)
      temp_block_idx <- which(vol_start >= df_behav$onset & vol_end <= df_behav$end)
      temp_trial_type <- as.character(df_behav$trial_type[temp_block_idx])
      df$trial_type[i] <- temp_trial_type

    } else if (sum(vol_end >= df_behav$onset & vol_end <= df_behav$end) == 1) {
      # 2. end of volume but not start of volume is within trial_type
      temp_block_idx <- min(which(vol_end >= df_behav$onset & vol_end <= df_behav$end))
      temp_block_start <- df_behav$onset[temp_block_idx]
      temp_difference <- vol_end - temp_block_start
      temp_trial_type <- as.character(df_behav$trial_type[temp_block_idx])
      if (temp_difference > thr) {
        df$trial_type[i] <- temp_trial_type
      }

    } else if (sum(vol_start >= df_behav$onset & vol_start <= df_behav$end) == 1) {
      # 3. start of volume but not end of volume is within trial_type
      temp_block_idx <- min(which(vol_start >= df_behav$onset & vol_start <= df_behav$end))
      temp_block_end <- df_behav$end[temp_block_idx]
      temp_difference <- temp_block_end - vol_start
      temp_trial_type <- as.character(df_behav$trial_type[temp_block_idx])
      if (temp_difference > thr) {
        df$trial_type[i] <- temp_trial_type
      }

    } else {
      # 4. not within trial_type
      df$trial_type[i] <- unlabeled_trial_type
    }

  }

  # return volume and trial_type
  df <- df %>%
    mutate(trial_type = as.factor(trial_type)) %>%
    select(volume, trial_type)

  return(df)
}
