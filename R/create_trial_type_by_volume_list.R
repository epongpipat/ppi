create_trial_type_by_volume_list <- function(events, tr_sec, n_vol, thr = 0.51, unlabeled_trial_type = "fixation") {

  total_fmri_time_sec <- tr_sec * n_vol

  # task data
  df_behav <- events %>%
    mutate(end = onset + duration)

  # new trial_typedata
  df <- tibble(onset = seq(0, total_fmri_time_sec, tr_sec),
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
