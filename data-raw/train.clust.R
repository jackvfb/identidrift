## code to prepare `train.clust` dataset goes here


# SETUP -------------------------------------------------------------------

library(densityClust)
library(tidyverse)
set.seed(123)


# SAMPLE & TRANSFORM------------------------------------------------------------------

# slice sample of 200 clicks from each species
samp <- train.ec %>%
  group_by(species) %>%
  slice_sample(n=120) %>%
  ungroup()

samp_rm <- samp %>%
  # drop metadata
  select(-c(UID:noiseLevel, BinaryFile, eventLabel,detectorName, db)) %>%
  # drop variables to avoid creating artifacts in the cluster plot.
  select(species, eventId, duration:peak, Q_10dB:centerkHz_3dB) %>%
  # perform logarithmic transform for non-normally distributed variables
  mutate(log_duration = log(duration), log_Q_3dB = log(Q_3dB), log_Q_10dB = log(Q_10dB), .keep = "unused")


# CLUSTER -----------------------------------------------------------------

# calculate Euclidean distances
dist <- samp_rm %>%
  select(-c(species, eventId)) %>%
  mutate(id = 1:n()) %>%
  column_to_rownames("id") %>%
  scale() %>%
  dist(method="euclidean")

train.clust <- densityClust(dist)

# set rho and delta values
train.clust <- findClusters(train.clust, rho=10, delta=2.5)

train.clust.table <- table(samp_rm$species, train.clust$clusters)

# SAVE --------------------------------------------------------------------

usethis::use_data(train.clust, overwrite = TRUE)
usethis::use_data(train.clust.table, overwrite = TRUE)
