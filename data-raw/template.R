## code to prepare `template` dataset goes here

files <- list.files("C:/Users/jackv/Documents/thesis-data/TemplateData",
                    full.names=TRUE)
names <- sapply(files, function (x) {str_remove(basename(x), "_Template.rds")})
obj <- lapply(files, readRDS)
names(obj) <- names
template <- list_rbind(obj, names_to="db")
usethis::use_data(template, overwrite = TRUE)
