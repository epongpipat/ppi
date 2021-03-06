create_func_volume_by_voxel_heatmeap <- function(data) {

  packages <- c("tictoc", "oro.nifti", "furrr", "purrr", "tidyr", "ggplot2")
  xfun::pkg_attach(packages, install = T, message = F)
  plan(multiprocess)

  df_flat <- flatten_dimension_all(data)

  df_flat <- df_flat %>%
    group_by(i,j,k) %>%
    nest() %>%
    mutate(voxel = 1:nrow(.)) %>%
    unnest()

  fig <- ggplot(df_flat, aes(l, voxel, fill = data)) +
    geom_raster() +
    theme_minimal() +
    scale_fill_distiller(palette = "RdBu") +
    labs(x = "\nVolume",
         y = "Voxel\n",
         fill = "BOLD")

  return(fig)

}
