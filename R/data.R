#' NBHF acoustic studies
#'
#' @description An acoustic study of drifts containing NBHF click detections presumed to come from Kogia spp., P. dalli, and P. phocoena.
#' The events were defined using the MTC module in PAMguard using the script in LINK and have been labelled "TP" or "FP".
#'
"nbhf_studies"

#' NBHF clicks
#'
#' @description Data frame containing PAMpal click data for all clicks in the studies, all species included. The channel with the highest dBPP is chosen for each click
#'
"nbhf_clicks"

#' Template match data
#'
#' @description Data frame containing MTC match scores for all clicks in the databases, prior to event definition
#'
"template"

#' #' Recall/precision data
#' #'
#' #' @description Table of manually determined FP, TP, FN for all events in the training set. Meant as an evaluation of our event definition process
#' #'
#' "rp"

#' Template clicks
#'
#' @description Binary click data from databases for each template click
#'
"click_templates"
