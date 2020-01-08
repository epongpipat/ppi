create_design_matrix <- function(psy_var, phys_var, ppi_var, nuisance_var) {
  colnames(ppi_var) <- str_replace(colnames(ppi_var), "psy_", "ppi_")
  data <- as.data.frame(cbind(psy_var, phys_var, ppi_var, nuisance_var))
  return(data)
}
