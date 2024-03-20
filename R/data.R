#' Training set -- Acoustic Studies
#'
#' @description An list of acoustic studies, one for each species class, containing ground-truthed NBHF click detections from Kogia spp., P. dalli, and P. phocoena.
#' The events were defined using the MTC module in PAMguard.
#'
"train"

#' Training set -- echolocation click data
#'
#' @description Data frame containing PAMpal click data for all clicks in the training set, all species included. The channel with the highest dBPP is chosen for each click.
#' A cluster is also assigned to each click based on density clustering.
#'
"train.ec"

#' NBHF BANTER Classifier
#'
#' @description Classification model trained to classify NBHF events to three species classes, Kogia, Dall's, and harbor porpoise.
#'
"bant"

#' NBHF Call Classifiers (Two flavors)
#'
#' @description List containing to random forest models trained on the same set of features. One is trained to classify species, and the other cluster.
#'
"call.rfs"

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

#' ADRIFT NBHF event predictions
#'
#' @description The final deliverable associated with this thesis project.
#'
"drift.predictions"

#' Survey raw click data
#'
#' @description Data frame containing PAMpal click data for all clicks in the survey data set. The channel with the highest dBPP is chosen for each click
#'
"drift.ec"
