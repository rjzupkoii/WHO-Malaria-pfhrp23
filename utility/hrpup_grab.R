tf <- tempfile()
download.file("https://github.com/OJWatson/hrpup/blob/main/analysis/data_derived/R6_WHO_Compliant_map.rds?raw=true", destfile = tf)
hrp2_map <- readRDS(tf)

saveRDS(hrp2_map, "R/data/map.rds")
