## General Properties of a building
General.Name <- "Test Building"
General.PlotOption <- TRUE
General.PlotName <- "Test Building"
  
## Building properties
  
# Uwb correction value for thermal bridges [W/m²K]
Building.Uwb <- 0.05

# Percentage of glazed surface
Building.Windows <- 0.4

# U-value for walls []
Building.UvalW <- 0.9

# U-value for roof []
Building.UvalR <- 0.6

# U-value for windows []
Building.UvalWindow <- 2.4

# Building Dimentions
Building.Dim <- c(12,12) 

# Building height
Building.h <- 3

# Air change rate [h-1]
Building.AirCRate <- 0.5

# Internal temperature [°C]
Building.Ti <- 20

# Internal heat emissions [W/m²]
Building.qi <- 5

# Ob = Building orientation
Building.Orientation <- 0

# StorageCapacity
#1 --> ? for light buildings:15 Wh/(sqm K) * Ve
#2 --> ? for heavy buildings: 50 Wh/(sqm K) * Ve
Building.StorageCapacity <- 50

# Building roof slope
Building.RoofSlope <- 30

## save
save(
  General.Name,
  General.PlotOption, 
  General.PlotName,
  Building.Uwb,
  Building.Windows, 
  Building.UvalW, 
  Building.UvalR, 
  Building.UvalWindow, 
  Building.Dim,
  Building.h,
  Building.AirCRate, 
  Building.Ti,
  Building.qi,
  Building.Orientation, 
  Building.StorageCapacity, 
  Building.RoofSlope,
  file = "./Data/BuildingDataDBug")