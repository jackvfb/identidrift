## code to prepare `ksstudy` dataset goes here

#setup -- is this section needed?
library(PAMpal)
source('R/cleaner-helpers.R')

#get file structure
basedir <- "C:/Users/jackv/Documents/thesis-data/mtc3"
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

# remove duplicate detectors
nbhf_studies <- lapply(studies2, rm_dup_dets)

# # get click Data
# clicks <- lapply(studies3, getClickData)
#
# #choose channel with greatest dBPP
# lapply(clicks, choose_ch)

#save
usethis::use_data(nbhf_studies, overwrite=TRUE)
