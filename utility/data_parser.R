# data_parser.R
#
# This is a development time script that is intended to take the output from 
# covert.py and prepare the data.RData file that will be used by the R Shiny app
library(dplyr)
library(malariaAtlas)
library(reshape2)
library(rlist)
library(sf)
library(yaml)

# Make sure we are working with a clean environment
rm(list = ls())

# Load the covariate data and use it to get the admin level 1 data from MAP
covars <- readRDS("utility/temp/covariate_ranges.rds")
worldmap <- malariaAtlas::getShp(ISO = na.omit(unique(covars$iso3c)), admin_level = c("admin1"))
worldmap <- sf::st_as_sf(worldmap)
rm(covars)

# Save the world map as downloaded from MAP as a shapefile in case it is needed
if (!file.exists("utility/temp/map_worldmap.shp")) {
  sf::st_write(worldmap, "utility/temp/map_worldmap.shp")  
}

# Remove the columns we don't need
worldmap <- worldmap[,!names(worldmap) %in% 
                       c("admn_level", "type_0", "type_1", "name_2", "id_2", "type_2", 
                         "name_3", "id_3", "type_3", "source", "country_level")]

# Load the regions and parse out the names, the data within the regions list can
# then be accessed as follows: index <- which(regions$names == 'Asia')
connection <- file("utility/out/mapping.yml")
regions <- read_yaml(connection)
regions$names <- unlist(list.flatten(regions, use.names = FALSE, classes = "character"))
rm(connection)

# Load the data set and covert the labeled regions to id_1
dataset <- read.csv( "utility/out/coded.csv")
mapping <- sf::st_drop_geometry(select(worldmap, "name_1", "id_1"))
dataset <- merge(x = dataset, y = mapping, by.x = "subregion", by.y = "name_1")
dataset <- dataset[, !names(dataset) %in% c("subregion")]
colnames(dataset)[colnames(dataset) == "id_1"] ="subregion"
rm(mapping)

# Save the data
save(worldmap, dataset, regions, file = "data/data.RData")
