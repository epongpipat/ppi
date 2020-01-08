create_phys_var <- function(phys, detrend_factor, upsample_factor = NULL, hrf) {

  phys_list <- list()
  phys_list$detrend <- detrend(phys, detrend_factor) %>% as.data.frame() %>% rename(phys = residual)
  phys_list$upsample <- upsample(phys_list$detrend, upsample_factor) %>% as.data.frame()
  colnames(phys_list$upsample) <- "phys"
  phys_list$deconvolve <- deconvolve_afni(phys_list$upsample, hrf) %>% as.data.frame()
  colnames(phys_list$deconvolve) <- "phys"
  return(phys_list)

}
