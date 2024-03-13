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

#' Training set density clusters
#'
#' @description Density cluster object with sample of click data from each class in training set.
#'
"train.clust"

#' Training set density clusters assignments
#'
#' @description Table with counts of each class in each cluster
#'
"train.clust.table"

#' Template match data
#'
#' @description Data frame containing MTC match scores for all clicks in the training set databases, prior to events being defined (i.e. match scores for both TPs and FPs)
#'
"templ.match"

#' Survey GPS data
#'
#' @description A list of data frames containing gps data for each drift in the survey.
#'
"drift.gps"

#' Survey data ready for BANTER predictions
#'
#' @description Survey event and call data exported for predictions by the NBHF banter model
#'
"drift.bant"

#' Survey raw click data
#'
#' @description Data frame containing PAMpal click data for all clicks in the survey data set. The channel with the highest dBPP is chosen for each click
#'
"drift.ec"
