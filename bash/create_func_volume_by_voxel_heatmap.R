create_func_volume_by_voxel_heatmeap <- function(in_file, out_file) {

  packages <- c("tictoc", "oro.nifti", "furrr", "purrr", "tidyr", "ggplot2")
  xfun::pkg_attach(packages, install = T, message = F)
  plan(multiprocess)

  df <- readNIfTI(in_file)
  df_flat <- flatten_dimension_all(df@.Data)

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

  ggsave(out_file, fig, width = 6, height = 4)

  return(fig)

}
