## code to prepare `predictions` dataset goes here


# SETUP -------------------------------------------------------------------

library(PAMpal)
library(banter)
library(identidrift)

# TRAIN CLASSIFIER -------------------------------------------------------

# export data for BANTER model
mdl <- export_banter(bindStudies(train),
                     dropVars = "Click_Detector_101_ici")

# split calls into putative call types
mdl <- split_calls(mdl)

# train model
bant <- NBHFbanter(mdl, 1000, 0.5, 10000, 0.5) #train model


# Helpers for plot
# p <- plotProximity(getBanterModel(bant))
# p$g +
#   scale_color_discrete(labels= c("*Kogia* spp.", "Dall's porpoise", "Harbor porpoise")) +
#   scale_fill_discrete(labels= c("*Kogia* spp.", "Dall's porpoise", "Harbor porpoise")) +
#   theme(legend.text = element_markdown())

# p <- plotImportance(getBanterModel(bant), plot.type = "heatmap")
# p +
#   scale_x_discrete(labels= c("*Kogia* spp.", "Dall's porpoise", "Harbor porpoise", "Mean Decrease Accuracy", "Mean Decrease Gini Index"))

# PREDICT -----------------------------------------------------------------

predictions <- predict(bant, drift.bant)$predict.df

locations <- drift.ec %>%
  group_by(eventId) %>%
  summarize(Latitude=median(Latitude),
            Longitude=median(Longitude),
            UTC=median(UTC))

drift.predictions <- inner_join(locations, predictions, by=join_by("eventId"=="event.id")) %>%
  mutate(db=str_extract(eventId, "\\w+_\\d+"))


# SAVE --------------------------------------------------------------------

usethis::use_data(bant, overwrite = TRUE)
usethis::use_data(drift.predictions, overwrite = TRUE)
