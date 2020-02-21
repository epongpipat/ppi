create_flag <- function(x, thr) {
  x <- as.data.frame(x)
  motion_lgl <- apply(x, 2, function(x) abs(x) >= thr)
  flag <- as.numeric(rowSums(motion_lgl) > 0) %>%
    as.data.frame()
  return(flag)
}



