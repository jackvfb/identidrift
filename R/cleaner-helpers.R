#' Helper function used to collect database files for forming a training data set.
#'
#' @param sp_drifts A character vector with the identifying names of the drifts of interest.
#' @param dbdir File path to a database directory containing .sqlite3 files.
#'
#' @return A character vector containing the full file paths to the sqlite3 files for each drift in \code{sp_drifts}.
#' @export
#'
index_dbdir <- function(sp_drifts, dbdir) {
  db <- list.files(dbdir, full.names=TRUE)
  i <- purrr::map_vec(sp_drifts, \(x) stringr::str_which(db, x))
  return(db[i])
}

#' Make an NBHF Acoustic Study
#'
#' @param db A character vector containing the file paths of the databases to be included in the study
#' @param bins The path to the binaries directory
#' @param sp_id A string with the code to be used for the species
#' @param sr Sample rate of the databases in herz (Hz)
#' @param hip Hi pass filter (filter_from) in kHz
#' @param lop Low pass filter (filter_to) in kHz
#'
#'
#' @return An AcousticStudy that has been filtered from 100-160 kHz, with an assumed sample rate of 384 kHz.
#' @export
#'
NBHFstudy <- function(db, sp_id, bins, sr = 384000, hip = 100, lop = 160) {
  pps <- PAMpal::PAMpalSettings(db = db,
                                binaries = bins,
                                sr_hz = sr,
                                filterfrom_khz = hip,
                                filterto_khz = lop,
                                winLen_sec = 0.0025
                                )
  study <- PAMpal::processPgDetections(pps = pps,
                                       mode = "db",
                                       id = sp_id
                                       )
  study <- PAMpal::setSpecies(study, method="manual", value=sp_id)
  #Not implemented: add GPS data?
  return(study)
}

#' Apply filters to NBHF study -- DELETE??
#'
#' @param study Acoustic study that has not had its clicks filtered. The function will remove agreed-upon false positives.
#'
#' @return Study with (some) false positives removed.
#' @export
#'
rm_fps <- function(study) {
  study <- filter(study, duration < 2)
  study <- filter(study, BW_3dB < 4 | BW_3dB > 13)
  #Not implemented: filter to select detection on only one channel (1 or 2). Choose to maximize dBPP
  return(study)
}

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

#' Select channel with best click
#'
#' @param clicks Click data from an AcousticStudy with fields \code{dBPP} and \code{UID}.
#'
#' @return Reduced data with the loudest Channel chosen for each UID
#' @export
#'
choose_ch <- function(clicks){
  result <- clicks %>%
    dplyr::group_by(UID) %>%
    dplyr::slice_max(dBPP, n=1) %>%
    dplyr::ungroup() %>%
    dplyr::distinct(UID)
  #add something to filter incomplete cases?
}


rm_dup_evs <- function(study) {
  evs <- names(events(study))
  keep <- !duplicated(evs)
  events(study) <- events(study)[keep]
  return(study)
}

#' Remove duplicate detectors from the events in an AcousticStudy, chosen to be the detector with the most detections
#'
#' @param study
#'
#' @return an acoustic study with just a single detector for each event
#' @export
#'
rm_dup_dets <- function(study) {
  evs <- events(study)
  for (i in seq_along(evs)) {
    e <- evs[[i]]
    myD <- which.max(lapply(detectors(e), nrow))
    detectors(e) <- detectors(e)[myD]
    evs[[i]] <- e
  }
  events(study) <- evs
  return(study)
}
