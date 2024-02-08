## code to prepare `nbhf_studies` dataset goes here
#
# #setup -- is this section needed?
# library(PAMpal)
# library(tidyverse)
# source('R/cleaner-helpers.R')

#get file structure
basedir <- "C:/Users/jackv/Documents/thesis-data/TrainingData"
bindir <- file.path(basedir, "binaries")
dbdir <- file.path(basedir, "db")

#db names by species
db <- list(ks = c("PG2_02_09_CCES_023_Ksp - Copy", "PG2_02_09_CCES_022_Ksp - Copy"),
          pd = c("Bangarang_Dalls - Copy", "CalCURSeas_Dalls - Copy", "PASCAL_Dalls_TowedArray - Copy"),
          pp = c("CalCURSeas_Harbor - Copy", "OPPS_008_Harbor - Copy", "OPPS_010_Harbor - Copy"))

#full paths
db <- lapply(db, index_dbdir, dbdir)

#make NBHF studies
studies <- mapply(NBHFstudy, db, names(db), MoreArgs = list(bins = bindir))

#remove duplicate events
studies2 <- lapply(studies, rm_dup_evs)

#choose just one detector
nbhf_studies <- lapply(studies2, choose_named_det)

#get binaries for chosen template clicks ALL FAKE CURRENTLY
templates <- data.frame(species = c("ks", "pd", "pd", "pp"),
                        tempNames = c("Ksp", "Pd_1", "Pd_2", "Pp"),
                        UID = c(2812000015, 308000031, 308000030, 2000156))
click_templates <- vector(mode="list")
for (i in 1:4) {
  thisSpecies <- templates$species[i]
  thisUID <- templates$UID[i]
  thisStudy <- nbhf_studies[[thisSpecies]]
  thisClick <- getBinaryData(thisStudy, thisUID)
  click_templates[i] <- thisClick
}
names(click_templates) <- templates$tempNames

# get click Data
nbhf_clicks <- lapply(nbhf_studies, getClickData)

#choose channel with greatest dBPP
nbhf_clicks <- list_rbind(lapply(nbhf_clicks, choose_ch))

#save
usethis::use_data(nbhf_studies, overwrite=TRUE)
usethis::use_data(nbhf_clicks, overwrite=TRUE)
usethis::use_data(click_templates, overwrite=TRUE)
