#' @title create_design_matrix
#'
#' @param psy_var data of psy variable
#' @param phys_var data of phys variable
#' @param ppi_var data of ppi variable
#' @param nuisance_var data of nuisance variables
#'
#' @return design matrix
#' @export
#'
#' @examples
#' # to be added
create_design_matrix <- function(psy_var, phys_var, ppi_var, nuisance_var = NULL) {
  if (!is.null(nuisance_var)) {
    data <- as.data.frame(cbind(psy_var, phys_var, ppi_var, nuisance_var))
  } else {
    data <- as.data.frame(cbind(psy_var, phys_var, ppi_var))
  }
  return(data)
}
