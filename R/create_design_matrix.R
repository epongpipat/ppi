#' @title create_design_matrix
#' @concept data_wrangling_wrapper_functions
#' @param psy_var psy variable data to add to design matrix
#' @param phys_var phys variable data to add to design matrix
#' @param ppi_var ppi variable data to add to design matrix
#' @param nuisance_var nuisance variable data to add to design matrix
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
