#' Helper function used to collect database files for forming a training data set.
#'
#' @param sp_drifts A character vector with the identifying names of the drifts of interest.
#' @param dbdir File path to a database directory containing .sqlite3 files.
#'
#' @return A character vector containing the full file paths to the sqlite3 files for each drift in sp_drifts.
#' @export
#'
index_dbdir <- function(sp_drifts, dbdir) {
  db <- list.files(dbdir, full.names=TRUE)
  i <- purrr::map_vec(sp_drifts, \(x) stringr::str_which(db, x))
  return(db[i])
}
