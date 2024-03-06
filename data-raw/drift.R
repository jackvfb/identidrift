## code to prepare `drift` dataset goes here

#setup
library(PAMpal)
library(tidyverse)

#get file structure
basedir <- "C:/Users/jackv/Documents/thesis-data/adrift"
bindir <- file.path(basedir, "binaries")
dbdir <- file.path(basedir, "db")

#db names
db <- c("ADRIFT_042 - Copy.sqlite3", "ADRIFT_043 - Copy.sqlite3", "ADRIFT_044 - Copy.sqlite3",
        "ADRIFT_045 - Copy.sqlite3", "ADRIFT_046 - Copy.sqlite3", "ADRIFT_047 - Copy.sqlite3",
        "ADRIFT_048 - Copy.sqlite3", "ADRIFT_049 - Copy.sqlite3", "ADRIFT_050 - Copy.sqlite3",
        "ADRIFT_051 - Copy.sqlite3", "ADRIFT_052 - Copy.sqlite3", "ADRIFT_053 - Copy.sqlite3",
        "ADRIFT_054 - Copy.sqlite3", "ADRIFT_055 - Copy.sqlite3", "ADRIFT_057 - Copy.sqlite3",
        "ADRIFT_058 - Copy.sqlite3", "ADRIFT_059 - Copy.sqlite3", "ADRIFT_061 - Copy.sqlite3",
        "ADRIFT_062 - Copy.sqlite3", "ADRIFT_063 - Copy.sqlite3", "ADRIFT_065 - Copy.sqlite3",
        "ADRIFT_067 - Copy.sqlite3", "ADRIFT_070 - Copy.sqlite3", "ADRIFT_071 - Copy.sqlite3",
        "ADRIFT_072 - Copy.sqlite3", "ADRIFT_073 - Copy.sqlite3", "ADRIFT_075 - Copy.sqlite3")
names(db) <- db

#full paths
db <- lapply(db, index_dbdir, dbdir)

#make acoustic study from drifter data
drift <- lapply(db, NBHFstudy, id = "adrift", bins = bindir)

#remove duplicate events
drift <- lapply(drift, rm_dup_evs)

#choose just one detector
drift <- lapply(drift, choose_named_det)

#remove FP events
drift <- lapply(drift, \(x) filter(x, eventLabel == "NBHF"))

#remove clicks with duration == 0 which must be false positives
drift <- lapply(drift, \(x) filter(x, duration != 0))

#add ICI to events
drift <- lapply(drift, calculateICI)

# ADD GPS -----------------------------------------------------------------

gpsFiles <- list.files("C:/Users/jackv/Documents/thesis-data/gps", pattern = ".csv", full.names = TRUE)
gpsAll <- purrr::map(gpsFiles, read_csv, col_select = c("Latitude", "Longitude", "UTC", "DriftName", "seadepth"))
names(gpsAll) <- basename(gpsFiles)
gpsAll <- list_rbind(gpsAll)

# Helper function
find_gps <- function(file) {
  for (d in gpsAll$DriftName) {
    if(grepl(d, file)) {
      return(filter(gpsAll, DriftName == d))
    }
  }
}

# generate list of data frames with gps data corresponding to each drift. This is
# necessary because drifts could have overlapping time yet be located in different
# areas. Meaning gps must be applied drift-wise.
drift.gps <- lapply(drift, \(x) list_rbind(lapply(files(x)$db, find_gps)))

#apply the GPS data to each drift, add thresh because some missing gps data in ADRIFT_048, leading to big time gap
drift <- mapply(\(x,y) addGps(x, gps=y, thresh = 20000), drift, drift.gps)

# get echolocation click Data
drift.ec <- lapply(drift, getClickData)

#choose channel with greatest dBPP
drift.ec <- list_rbind(lapply(drift.ec, choose_ch))

#save
usethis::use_data(drift, overwrite=TRUE)
usethis::use_data(drift.ec, overwrite=TRUE)
usethis::use_data(drift.gps, overwrite = TRUE) #in case the complete paths are needed later.
