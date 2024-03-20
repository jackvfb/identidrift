#' Split a singular call type into multiple call types based on peak frequency, 3 bands (breaks at 120, 140 kHz)
#'
#' @param x Data formatted to initialize a banter model, with a single call type labeled as "Click_Detector_101"
#'
#' @return A banter-ready data object with 3 call types, instead of a singular call type
#' @export
#'
split_calls <- function(x) {
  #get the singular detector
  d <- x$detectors$Click_Detector_101
  #create categorical "band" variable by subdividing all dectector data into three frequency bands
  d <- mutate(d, band = cut(d$peak, breaks=c(120,140,160)))
  # split detector data into three seperate data frames by band
  new_d <- d %>%
    nest(data = -band) %>%
    mutate(floor = map_dbl(data, \(x) min(x$peak))) %>%
    arrange(floor) %>%
    pull(data)
  # label bands
  names(new_d) <- c("lorange", "midrange", "hirange")
  # replace detector with three bands
  x$detectors <- new_d
  return(x)
}

#' Make an NBHF classification banter model
#'
#' @param x Training data formatted to initialize a banter model
#' @param det_ntree Number of trees to use when growing the detector random forest
#' @param ev_ntree Number of trees to use when growing the event random forest
#' @param det_ss Sample size to use when growing the detector random forest
#' @param ev_ss Sample size to use when growing the event random forest
#'
#' @return A banter model trained to classify NBHF clicks
#' @export
#'
NBHFbanter <- function(x, det_ntree, det_ss, ev_ntree, ev_ss) {
  bantMdl <- banter::initBanterModel(x$events)
  bantMdl <- banter::addBanterDetector(bantMdl, data=x$detectors, ntree=det_ntree,
                                       importance=TRUE, sampsize = det_ss)
  bantMdl <- banter::runBanterModel(bantMdl, ntree = ev_ntree, sampsize = ev_ss)
  return(bantMdl)
}
