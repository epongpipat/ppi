#' build_afni_cmd
#' @concept support
#' @param afni_list list that contains the program name and options to create command
#' @return return afni command
#' @export
#' @import afnir
#' @examples
#' build_afni_cmd(afni_list = list(program = "3dcalc",
#'                                 opt = list(a = "a.nii.gz",
#'                                            b = "b.nii.gz",
#'                                            expr = "'(a*b)'"),
#'                                            prefix = c.nii.gz))
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
