build_afni_cmd <- function(afni_list) {

  afni_cmd <- afni_list$program

  for (i in 1:length(afni_list$opt)) {
    temp_afni_opt_name <- names(afni_list$opt[i])
    temp_afni_opt_value <- afni_list$opt[[i]]
    temp_afni_opt <- paste0("-", temp_afni_opt_name, " ", temp_afni_opt_value)
    afni_cmd <- paste(afni_cmd, temp_afni_opt)
  }

  cat(afni_cmd, "\n")
  return(afni_cmd)
}
