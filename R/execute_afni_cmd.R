#' @title execute_afni_cmd
#' @concept helper
#' @param afni_cmd afni command to execute within R
#' @param afni_path afni path (default: NULL). the default option will use \code{afnir::get_afni()} to obtain the path
#' @return
#' @export
#' @import afnir
#' @examples
#' to be added
execute_afni_cmd <- function(afni_cmd, afni_path = NULL) {
  if (is.null(afni_path)) {
    afni_path <- get_afni()
  }
  sys_cmd <- paste0(afni_path, afni_cmd)
  system(sys_cmd)
}
