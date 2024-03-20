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
