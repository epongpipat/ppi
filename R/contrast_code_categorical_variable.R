#' @title contrast_code_categorical_variable
#' @concept data_wrangling
#' @param data data to apply contrast code
#' @param contrast contrast code
#'
#' @return
#' @export
#' @import dplyr
#' @concept data_wrangling
#' @examples
#' library(dplyr)
#'
#' # this examples uses the following data from openneuro.org
#' # https://openneuro.org/datasets/ds000171/versions/00001
#'
#' # in this dataset, participants listen to either positive music,
#' # negative music, or tones (control). Positive and negative musical stimulus
#' # are presented for 31.5 seconds and tones are presented for 33 seoncds.
#' # After each stimulus, participants have 3 seconds to report their valence
#' # (from very sad to very happy) and arousal (from very passive to very #
#' # active). the repitition time (tr) for this dataset was 3 and the number of
#' # volumes collected for this was run 105.
#'
#' # read events from openneuro.org
#' psy_events <- readr::read_tsv(url("https://openneuro.org/crn/datasets/ds000171/snapshots/00001/files/sub-control01:func:sub-control01_task-music_run-1_events.tsv")) %>%
#'   mutate(trial_type = as.factor(trial_type)) %>%
#'   create_trial_type_by_volume_list(., tr = 1.5, n_volumes = 105, unlabeled_trial_type = "response")
#'
#' summary(psy_events$trial_type)
#'
#' # orthogonal contrast code that test:
#' # 1. stimulus vs response
#' # 2. music vs tones
#' # 3. positive music vs negative music
#' psy_contrast_table <- as.data.frame(cbind(stimulus_vs_response = c(1, 1, -3, 1)/4,
#'                                           music_vs_tones = c(1, 1, 0, -2)/3,
#'                                           positive_music_vs_negative_music = c(-1, 1, 0, 0)/2))
#'
#' # run function
#' psy_contrast <- contrast_code_categorical_variable(data = psy_events,
#'                                                    contrast = psy_contrast_table)
#'
#' head(psy_contrast)
#'
#' # references:
#' # Lepping RJ, Atchley RA, Chrysikou E, Martin LE, Clair AA, Ingram RE, et al. Neural processing of emotional musical and nonmusical stimuli in depression.  PlosONE.  In Press.
#' # Lepping RJ, Atchley RA, Savage CR. Development of a Validated Emotionally Provocative Musical Stimulus Set for Research. Psychology of Music. 2015; online before print. doi:10.1177/0305735615604509.
#' # Lepping RJ, Atchley RA, Martin LE, Patrician TM, Stroupe N, Brooks WM, et al. Limbic responses to positive and negative emotionally evocative music: An fMRI study.  Society for Neuroscience annual meeting 2012 Oct 13-18; New Orleans, LA 2012.
#' # Lepping RJ, Atchley RA, Martin LE, Brooks WM, Clair AA, Ingram RE, et al. Musical and nonmusical sounds evoke different patterns of neural activity: An fMRI study.  Psychonomic Society annual meeting; 2012 Nov 14-18; Minneapolis, MN 2012.
#' # Lepping RJ, Atchley RA, Martin LE, Patrician TM, Ingram RE, Clair AA, et al. The effect of musical experiences and musical training on neural responses to emotionally evocative music and non-musical sounds.  Social and Affective Neuroscience Society annual conference 2013 Apr 12-13; San Francisco, CA 2013
#' # Lepping RJ, Atchley RA, Patrician TM, Stroupe NN, Martin LE, Ingram RE, et al. Music to my ears: Neural responsiveness to emotional music and sounds in depression.  Society of Biological Psychiatry annual scientific convention 2013 May 16-18; San Francisco, CA 2013.
contrast_code_categorical_variable <- function(data, contrast) {

  # apply contrast
  contrasts(data$trial_type) <- as.matrix(contrast)

  # create design matrix
  df_new <- model.matrix(~ trial_type, data) %>%
    as_tibble() %>%
    select(-"(Intercept)")

  df_new <- apply(df_new, 2, as.numeric)

  colnames(df_new) <- paste0("psy_", colnames(contrast))

  df_new <- cbind(data, df_new)

  return(df_new)
}
