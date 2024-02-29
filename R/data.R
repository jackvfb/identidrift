#' Training set -- Acoustic Studies
#'
#' @description An list of acoustic studies, one for each species class, containing ground-truthed NBHF click detections from Kogia spp., P. dalli, and P. phocoena.
#' The events were defined using the MTC module in PAMguard.
#'
"train"

#' Training set -- echolocation click data
#'
#' @description Data frame containing PAMpal click data for all clicks in the training set, all species included. The channel with the highest dBPP is chosen for each click
#'
"train.ec"

#' Template match data
#'
#' @description Data frame containing MTC match scores for all clicks in the training set databases, prior to events being defined (i.e. match scores for both TPs and FPs)
#'
"templ.match"
