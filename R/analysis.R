#' Get click spectra
#'
#' @param study AcousticStudy containing clicks whose spectra will be extracted
#'
#' @return data frame containing the spectrum for every single click in the study (both channels).
#' @export
#'
studyspec <- function(study) {
  evs <- 1:length(PAMpal::events(study))
  l <- PAMpal::calculateAverageSpectra(study, evNum = evs, norm = TRUE)
  m <- l$allSpec
  df <- data.frame(m, row.names = l$freq)
  colnames(df) <- l$UID
  result <- df[,!duplicated(l$UID)]
  return(result)
}

#' Make a generalized spectrum for plotting
#'
#' @param study_spec A dataframe that contains the spectra for all clicks in a study, generated using `getStudySpectra()`
#'
#' @return tibble with data for a "generalized spectrum" ready to plot
#' @export
#'
genspec <- function(study_spec) {
  study_spec %>%
    #make into a tibble for ease of visualization
    tibble::as_tibble(rownames = "freq") %>%
    #pivot data to allow summary statistics to be generated for discrete frequencies
    tidyr::pivot_longer(cols = -freq, names_to = "UID") %>%
    #extra step since freq is chr
    dplyr::mutate(freq = as.numeric(freq)) %>%
    #group by frequency value to generate summary statistics
    dplyr::group_by(freq) %>%
    #variables needed are a central measure and an upper and lower conf. int.
    # using interquartile range to represent confidence interval.
    dplyr::summarize(mn = mean(value),
                     lci = quantile(value, probs = 0.25),
                     uci = quantile(value, probs = 0.75)) %>%
    #frequency band of interest is 100 kHz to 160 kHz
    dplyr::filter(freq >= 100000 & freq <= 160000)
}
