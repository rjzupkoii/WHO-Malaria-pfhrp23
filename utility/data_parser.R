# data_parser.R
# 
# This is a development time script that is intended to take the output from 
# covert.py and prepare the data.RData file that will be used by the R Shiny app
library(dplyr)
library(reshape2)
library(rlist)
library(sf)
library(yaml)

# make sure we are working with a clean environment
rm(list = ls())

# Load the regions and parse out the names, the data within the regions list can
# then be accessed as follows: index <- which(regions$names == 'Asia')
connection <- file('utility/out/mapping.yml')
regions <- read_yaml(connection)
regions$names <- unlist(list.flatten(regions, use.names = FALSE, classes = "character"))
rm(connection)

# Load in the larger data set
dataset <- read.csv('utility/out/coded.csv')
dataset <- distinct(dataset)

# Load in the Natural Earth shapefile
unzip('data/ne_50m_admin_0_countries.zip', exdir = 'temp')
countries <- read_sf('temp/ne_50m_admin_0_countries.shp')
unlink('temp', recursive = TRUE)

# Save the data
save(countries, dataset, regions, file = 'data/data.RData')
