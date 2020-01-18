
# `ppi` : Psychophysiological Interaction (PPI)

A neuroimaging package to “easily” perform PPI analyses for task fMRI.

Note: This package is still being developed and will likely change a
lot. Please use cautiously.

## Installation

``` r
devtools::install_github("epongpipat/ppi")
```

## Data Wrangling

From 3-column format events file (i.e., onset, duration, trial\_type)
and physiological time series from region of interest to PPI design
matrix under 4 seconds\!

``` r
library(ppi)
library(dplyr)

# define hrf ----
hrf <- create_hrf_afni(hrf = "spmg1", tr = 3, upsample_factor = 16)
```

    ## 3dDeconvolve -nodata 400 0.1875 -polort -1 -num_stimts 1 -stim_times 1 1D:0 SPMG1 -x1D /var/folders/qs/c3q2tkwj5xb7700v6bg00m480000gn/T//RtmpRh1vFK/file4c9861b8b5ec -x1D_stop

``` r
# load events file ----
psy_url <- "https://openneuro.org/crn/datasets/ds000171/snapshots/00001/files/sub-control01:func:sub-control01_task-music_run-1_events.tsv"
psy_events <- readr::read_tsv(url(psy_url)) %>%
  mutate(trial_type = as.factor(trial_type))

# define contrast code ----
# orthogonal contrast code:
# 1. stimulus vs response
# 2. music vs tones
# 3. positive music vs negative music
psy_contrast_table <- cbind(stimulus_vs_response = c(1, 1, -3, 1)/4,
                            music_vs_tones = c(1, 1, 0, -2)/3,
                            positive_music_vs_negative_music = c(-1, 1, 0, 0)/2)

# load physiological time series data from region of interest ----
phys_file <- "examples/sub-control01_task-music_run-1_bold_space-subj_vox-32-24-38.csv"
phys_data <- readr::read_csv(phys_file, col_names = F)

tictoc::tic()
data_wrangling <- data_wrangling(psy_events_data = psy_events, 
                                 psy_unlabeled_trial_type = "response", 
                                 psy_contrast_table = psy_contrast_table, 
                                 phys_data = phys_data, 
                                 detrend_factor = 2,
                                 hrf = hrf, 
                                 tr = 3, 
                                 n_volumes = 105, 
                                 upsample_factor = 16, 
                                 deconvolve = TRUE,
                                 afni_quiet = TRUE)
```

    ## waver -FILE 0.1875 /var/folders/qs/c3q2tkwj5xb7700v6bg00m480000gn/T//RtmpRh1vFK/file4c9845578787.1D -input /var/folders/qs/c3q2tkwj5xb7700v6bg00m480000gn/T//RtmpRh1vFK/file4c98383d5fb9.1D -numout 1680 
    ## waver -FILE 0.1875 /var/folders/qs/c3q2tkwj5xb7700v6bg00m480000gn/T//RtmpRh1vFK/file4c984c26bbdb.1D -input /var/folders/qs/c3q2tkwj5xb7700v6bg00m480000gn/T//RtmpRh1vFK/file4c9860142b4c.1D -numout 1680 
    ## waver -FILE 0.1875 /var/folders/qs/c3q2tkwj5xb7700v6bg00m480000gn/T//RtmpRh1vFK/file4c983623b3bd.1D -input /var/folders/qs/c3q2tkwj5xb7700v6bg00m480000gn/T//RtmpRh1vFK/file4c983a1cc279.1D -numout 1680

``` r
tictoc::toc()
```

    ## 2.675 sec elapsed

``` r
summary(data_wrangling)
```

    ##               Length Class      Mode
    ## params        3      -none-     list
    ## psy_var       6      -none-     list
    ## phys_var      3      -none-     list
    ## ppi_var       3      -none-     list
    ## design_matrix 7      data.frame list

## Analysis (Under Construction)

## Visualization (Under Construction)

## Acknowledgements

This package relies on a variety of R packages (i.e., `tidyverse`,
`afnir`, `furrr`) and neuroimaging programs (i.e, AFNI and FSL).

Note: AFNI and FSL functions will eventually (hopefully) be replaced so
that the package only uses R.

## PPI References:

Friston, K. J., Buechel, C., Fink, G. R., Morris, J., Rolls, E., &
Dolan, R. J. (1997). Psychophysiological and modulatory interactions in
neuroimaging. NeuroImage, 6(3), 218–229.
<https://doi.org/10.1006/nimg.1997.0291>

Gitelman, D. R., Penny, W. D., Ashburner, J., & Friston, K. J. (2003).
Modeling regional and psychophysiologic interactions in fMRI: The
importance of hemodynamic deconvolution. NeuroImage, 19(1), 200–207.
<https://doi.org/10.1016/S1053-8119(03)00058-2>

McLaren, D. G., Ries, M. L., Xu, G., & Johnson, S. C. (2012). A
generalized form of context-dependent psychophysiological interactions
(gPPI): A comparison to standard approaches. NeuroImage, 61(4),
1277–1286. <https://doi.org/10.1016/j.neuroimage.2012.03.068>

Cisler, J. M., Bush, K., & Steele, J. S. (2014). A comparison of
statistical methods for detecting context-modulated functional
connectivity in fMRI. NeuroImage, 84, 1042–1052.
<https://doi.org/10.1016/j.neuroimage.2013.09.018>

Di, X., Reynolds, R. C., & Biswal, B. B. (2017). Imperfect
(de)convolution may introduce spurious psychophysiological interactions
and how to avoid it. Human Brain Mapping, 38(4), 1723–1740.
<https://doi.org/10.1002/hbm.23413>
