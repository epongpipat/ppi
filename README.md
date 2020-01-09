# `ppi`: Psychophysiological Interaction (PPI)

A package to "easily" perform PPI analyses for task fMRI.

Note: This package is still being developed and will likely change a lot. Use cautiously.

## Data Wrangling
1. `create_hrf()` - Creates the hemodynamic response function (HRF) time series
2. `create_psy_var()` - Creates psychological variables
3. `create_phy_var()` - Creates physiological variables
4. `create_ppi_var()` - Creates psychophysiological interaction (PPI) variables
5. `create_design_matrix()` - Create design matrix

<br>`data_wrangling()` - Uber script of the above

## Analysis (Under Construction)

### Visualization (Under Construction)

## Acknowledgements
This package relies on a variety of R packages (i.e., `tidyverse`, `afnir`, `furrr`) and neuroimaging programs (i.e, AFNI and FSL).

Note: AFNI and FSL will eventually (hopefully) be replaced to stay solely within R.
