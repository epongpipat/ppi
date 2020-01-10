#' @title create_design_matrix
#'
#' @param psy_var
#' @param phys_var
#' @param ppi_var
#' @param nuisance_var
#'
#' @return design matrix
#' @export
#'
#' @examples
create_design_matrix <- function(psy_var, phys_var, ppi_var, nuisance_var = NULL) {
  if (!is.null(nuisance_var)) {
    data <- as.data.frame(cbind(psy_var, phys_var, ppi_var, nuisance_var))
  } else {
    data <- as.data.frame(cbind(psy_var, phys_var, ppi_var))
  }
  return(data)
}
