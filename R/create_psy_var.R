create_psy_var <- function(events, contrast_table, hrf, tr, n_volumes, upsample_factor = NULL) {

  psy_list <- list()
  psy_list$trial_type_by_volume <- as.data.frame(create_trial_type_by_volume_list(events, tr, n_volumes))
  psy_list$contrast <- as.data.frame(contrast_code_categorical_variable(psy_list$trial_type_by_volume, contrast_table)) %>% select(contains("psy"))
  psy_list$upsample <- as.data.frame(apply(psy_list$contrast, 2, function(x) upsample(x, upsample_factor)))
  psy_list$convolve <- as.data.frame(apply(psy_list$upsample, 2, function(x) convolve_afni(x, hrf, tr, n_volumes, upsample_factor)))
  psy_list$downsample <- as.data.frame(apply(psy_list$convolve, 2, function(x) downsample(x, upsample_factor)))
  return(psy_list)

}
