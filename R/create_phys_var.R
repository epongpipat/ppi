create_phys_var <- function(phys, detrend_factor, upsample_factor = NULL, hrf) {

  phys_list <- list()
  phys_list$phys_detrend <- detrend(phys_list$phys, detrend_factor)
  phys_list$phys_upsample <- upsample(phys_list$phys_detrend, upsample_factor)
  phys_list$phys_deconvolve <- deconvolve_afni(phys_list$phys_upsample, hrf)
  return(phys_list)

}
