# Psychophysiological Interaction (PPI)

A script to help perform PPI analyses for fMRI. Mostly, scripts to help pre-process the data to get the data ready to perform a standard interaction in the GLM framework.

The purpose of this package is to allow for one script to perform the entire PPI process while printing an HTML file to show it's progress.

## Functions

## 1. create_psy_vars() - Create psychological variables

Input:

1. events (csv/tsv of stim onsets and durations)
2. contrast coding scheme (csv/tsv)
2. kernel
3. upsampling rate

Output:

1. contrast coded psy time series (upsampled)
2. convolved psy time series (upsampled)
3. convolved psy time series (downsampled)

## 2. create_phy_vars() - Create physiological variables

Input: 

1. phys time series
2. deconvolve option
3. hrf kernel
4. upsampling rate

Output:

1. phys time series (upsampled)
2. phys time series (detrended)
3. deconvolved phys time series (upsampled)
4. deconvolved phys time series (downsampled)

## 3. create_ppi_vars() - Create ppi variables

Input:

1. contrast psy time series (upsampled)
2. deconvolved phys time series (upsampled)
3. upsampling rate

Output:

1. ppi (upsampled)
2. convolved ppi (upsampled)
3. convolved ppi (downsampled)
4. ppi (downsampled)

## 4. create_design_mat() - Create design matrix

Input:

1. convolved psy time series (downsampled)
2. phys time series (detrended)
3. intercept/temporal detrend concatente or differing slopes
4. covariates file (csv/tsv file)

Output:

1. csv/tsv file

## 5. concatenate_nii() - Concatenate nifti files

## 6. analyze() - Perform first/subject-level analyses

Input:

1. design matrix
2. nii (whole brain) or csv/tsv (roi set)

Output:

1. coefficient table with estimate, se, t-stat, p-value, r^2, and adj r^2 (csv/tsv)
2. overall model performance metrics with r^2 and adj^2 of the omnibus test, loglik, aic, bic, df, df.residual (csv/tsv)
4. tolerance (csv/tsv)
3. predicted values (csv/tsv or nii depending on input)
4. resdiuals (csv/tsv or nii depending on input)

## Random

I would like to make a script that combines all of the above scripts into one single bash script by having multiple input values

### This package currently relies on AFNI and FSL functions. They will hopefully all be replaced to be solely in R.

### I also need some functions for visualizing the data at each step.

## Notations

in_ - prefix of parameters signifying file is input 
out_ - prefix of parameters signifying file is output
nii <- nifti file as either .nii or .nii.gz
design_matrix <- design matrix

