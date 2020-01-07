contrast_code_categorical_variable <- function(data, contrast) {

  # apply contrast
  contrasts(data$trial_type) <- contrast

  # create design matrix
  df_new <- model.matrix(~ trial_type, data) %>%
    as_tibble() %>%
    select(-"(Intercept)")

  df_new <- apply(df_new, 2, as.numeric)

  colnames(df_new) <- paste0("psy_", colnames(contrast))

  df_new <- cbind(data, df_new)

  return(df_new)
}
