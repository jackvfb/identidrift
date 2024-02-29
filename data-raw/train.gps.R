## code to prepare `train.gps` dataset goes here

#setup
library(PAMpal)
library(tidyverse)

gpsFiles <- list.files("C:/Users/jackv/Documents/thesis-data/gps", pattern = ".csv", full.names = TRUE)
gpsAll <- purrr::map(gpsFiles, read_csv, col_select = c("Latitude", "Longitude", "UTC", "DriftName", "seadepth"))
names(gpsAll) <- basename(gpsFiles)
#remove point over land for one of the drifts in the training set.
gpsAll[["OPPS_010_GPS.csv"]] <- gpsAll[["OPPS_010_GPS.csv"]][1,]
gpsAll <- list_rbind(gpsAll)

# Helper function
find_gps <- function(file) {
  for (drift in gpsAll$DriftName) {
    if(grepl(drift, file)) {
      return(filter(gpsAll, DriftName == drift))
    }
  }
}

train.gps <- lapply(train, \(x) list_rbind(lapply(files(x)$db, find_gps)))
use_data(train.gps, overwrite = TRUE)
