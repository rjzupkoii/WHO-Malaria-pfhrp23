# data_parser.R
#
# This is a development time script that is intended to take the output from 
# covert.py and prepare the data.RData file that will be used by the R Shiny app
#
# Since this file is not part of the main R Shiny App, the following additional
# packages need to be installed to run it: install.packages("malariaAtlas")
library(dplyr)
library(malariaAtlas)
library(reshape2)
library(rlist)
library(sf)
library(yaml)

# Make sure we are working with a clean environment
rm(list = ls())

SIMPLE_WORLDMAP <- "utility/data/map_worldmap_simple.zip"

# Check to see if a simplified world map exists, this would have been prepared 
# in other software like ArcGIS Pro.
if (!file.exists(SIMPLE_WORLDMAP)) {
  # Load the covariate data and use it to get the admin level 1 data from MAP
  covars <- readRDS("utility/temp/covariate_ranges.rds")
  worldmap <- malariaAtlas::getShp(ISO = na.omit(unique(covars$iso3c)), admin_level = c("admin1"))
  worldmap <- sf::st_as_sf(worldmap)
  rm(covars)
  
  # Save the world map as downloaded from MAP as a shapefile in case it is needed
  if (!file.exists(SIMPLE_WORLDMAP)) {
    sf::st_write(worldmap, SIMPLE_WORLDMAP)  
  }
  print("Using map_worldmap.shp for worldmap")
} else {
  out_directory <- tempfile()
  unzip(SIMPLE_WORLDMAP, exdir = out_directory)
  worldmap <- sf::st_read(dsn = out_directory)
  print("Using map_worldmap_simple.shp for worldmap")
}

# Load the data set and covert the labeled admin level 2 (i.e., subregion) to id_1
dataset <- read.csv( "utility/out/coded.csv")
mapping <- sf::st_drop_geometry(select(worldmap, "name_1", "id_0", "id_1"))
dataset <- merge(x = dataset, y = mapping, by.x = "subregion", by.y = "name_1")
dataset <- dataset[, !names(dataset) %in% c("iso", "subregion")]
rm(mapping)

# Load the mapping of sub-regions and the global region ids
mapping <- read.csv("utility/out/mapping.csv")
mapping <- mapping[, !names(mapping) %in% c("iso", "region")]
dataset <- merge(x = dataset, y = mapping, by.x = "id_1", by.y = "id_1")
rm(mapping)

# Rename the columns
colnames(dataset)[colnames(dataset) == "id_0"] = "map_country"
colnames(dataset)[colnames(dataset) == "id_1"] = "map_subregion"
colnames(dataset)[colnames(dataset) == "region_id"] = "global_region"

# Remove the columns we don't need
worldmap <- worldmap[,!names(worldmap) %in% 
                       c("iso", "admn_level", "country_level", "id_2", "id_3",
                         "name_0", "name_1", "name_2", "name_3",
                         "type_0", "type_1", "type_2", "type_3", "source")]

# Save the data and clean-up
save(worldmap, dataset, file = "R/data/data.RData")
rm(SIMPLE_WORLDMAP)
