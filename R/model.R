#' Split a singular call type into multiple call types based on peak frequency
#'
#' @param x Data formatted to initialize a banter model, with a single call type
#'
#' @return A banter-ready data object with three call types, instead of a singular call type
#' @export
#'
split_calls <- function(x) {
  #get the singular detector
  d <- x$detectors$Click_Detector_101
  #create categorical "band" variable by subdividing all dectector data into three frequency bands
  d <- mutate(d, band = cut(d$peak, breaks=3))
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
