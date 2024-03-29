% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convolve_afni.R
\name{convolve_afni}
\alias{convolve_afni}
\title{convolve_afni}
\usage{
convolve_afni(
  data,
  hrf,
  tr,
  n_volumes,
  upsample_factor = NULL,
  afni_path = NULL,
  afni_quiet = FALSE
)
}
\arguments{
\item{data}{data to convolve}

\item{hrf}{hemodynamic response function (hrf) time series}

\item{tr}{repition time (tr) in seconds}

\item{n_volumes}{number of volumes or time points}

\item{upsample_factor}{factor to upsample data for convolution step}
}
\value{

}
\description{
convolve_afni
}
\examples{
data <- sample(7500:15000, 10, T)/100
hrf <- create_hrf_afni("spmg1", 16)
convolve_afni(data, hrf, 1.5, 100, 16)
}
\concept{data_wrangling}
