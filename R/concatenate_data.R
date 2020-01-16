concatenate_data <- function(data_list, direction = "row") {

  if(!is.list(data_list)) {
    stop("data_list must be a list of datasets")
  }

  n_data <- length(data_list)
  if (n_data == 1) {
    stop("data_list must contain more than one dataset")
  }

  if (direction == "row") {
    data <- NULL
    for (i in 1:n_data) {
      data <- rbind(data, data_list[[i]])
    }
  } else if (direction == "col") {
    data <- NULL
    for (i in 1:n_data) {
      data <- cbind(data, data_list[[i]])
    }
  } else{
    stop("direction must be either row or col")
  }
  return(as.data.frame(data))
}
