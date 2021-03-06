% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_parameter_derivative_polynomial.R
\name{calculate_parameter_temporal_derivative_polynomial}
\alias{calculate_parameter_temporal_derivative_polynomial}
\title{calculate_parameter_temporal_derivative_polynomial}
\usage{
calculate_parameter_temporal_derivative_polynomial(
  data,
  temporal_derivative = 1,
  polynomial = 2
)
}
\arguments{
\item{data}{data to have temporal derivatives and polynomial calculated}

\item{temporal_derivative}{temporal derivative value (default: 1)}

\item{polynomial}{polynomial value (default: 2)}
}
\value{
data.frame of original data along with its temporal derivatives and its polynomial
}
\description{
calculate_parameter_temporal_derivative_polynomial
}
\examples{
data <- data.frame(cbind(roi_1 = sample(7500:15000, 10, T)/100,
                         roi_2 = sample(7500:15000, 10, T)/100))
calculate_parameter_temporal_derivative_polynomial(data)
}
\concept{data_wrangling}
