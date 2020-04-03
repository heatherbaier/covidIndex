library(rPref)
library(rgdal)
library(shiny)
library(rgeos)
library(leaflet)
library(shinythemes)
library(DT)


# shp <- readOGR("./data/ForHeather_Final/Untitled2.shp")
# names(shp)[12] <- "longitude"
# names(shp)[13] <- "latitude"
# shp@data$radius <- shp@data$PrcSDstc + abs(min(shp$PrcSDstc, na.rm = TRUE))
# shp

# df <- shp@data
# sky1 <- psel(df, low(MdianInc) * low(PrcSDstc)) 
