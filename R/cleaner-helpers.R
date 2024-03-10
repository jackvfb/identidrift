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
#' @param id A string for the study ID
#' @param sr Sample rate of the databases in herz (Hz)
#' @param hip Hi pass filter (filter_from) in kHz
#' @param lop Low pass filter (filter_to) in kHz
#'
#'
#' @return An AcousticStudy that has been filtered from 100-160 kHz, with an assumed sample rate of 384 kHz.
#' @export
#'
NBHFstudy <- function(db, id, bins, sr = 384000, hip = 100, lop = 160) {
  pps <- PAMpal::PAMpalSettings(db = db,
                                binaries = bins,
                                sr_hz = sr,
                                filterfrom_khz = hip,
                                filterto_khz = lop,
                                winLen_sec = 0.0025
                                )
  study <- PAMpal::processPgDetections(pps = pps,
                                       mode = "db",
                                       id = id
                                       )
  return(study)
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
   # dplyr::mutate(UID=as.numeric(UID)) %>%
    dplyr::group_by(UID) %>%
    dplyr::slice_max(dBPP, n=1) %>%
    dplyr::ungroup() %>%
    dplyr::distinct(UID, .keep_all=TRUE)
  #add something to filter incomplete cases?
}

#' Remove duplicate events in an AcousticStudy
#'
#' @param study AcousticStudy object
#'
#' @return an acoustic study with no duplicated events
#' @export
#'
rm_dup_evs <- function(study) {
  evs <- names(events(study))
  keep <- !duplicated(evs)
  events(study) <- events(study)[keep]
  return(study)
}

#' Remove duplicate detectors from the events in an AcousticStudy, chosen to be the detector with the most detections
#'
#' @param study AcousticStudy object
#'
#' @return an acoustic study with just a single detector for each event
#' @export
#'
choose_max_det <- function(study) {
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

#' Remove duplicate detectors from the events in an AcousticStudy, chosen by name match
#'
#' @param study AcousticStudy object
#' @param keep String with the name of the detector you wish to retain
#'
#' @return an acoustic study with just a single detector for each event
#' @export
#'
drop_detectors <- function(study, keep) {
  evs <- events(study)
  for (i in seq_along(evs)) {
    e <- evs[[i]]
    choose <- grep(keep,names(detectors(e)))
    detectors(e) <- detectors(e)[choose]
    evs[[i]] <- e
  }
  events(study) <- evs
  return(study)
}
