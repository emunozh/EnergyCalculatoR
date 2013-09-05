## General Properties of a building
T.General.Name <- "Test Building"
T.General.PlotOption <- TRUE
T.General.PlotName <- "Test Building"
  
## Building properties
  
# Uwb correction value for thermal bridges [W/m²K]
T.Building.Uwb <- 0.05

# Percentage of glazed surface
T.Building.Windows <- 0.4

# U-value for walls []
T.Building.UvalW <- 0.9

# U-value for roof []
T.Building.UvalR <- 0.6

# U-value for windows []
T.Building.UvalWindow <- 2.4

# Building Dimentions
T.Building.Dim <- c(6,12) 

# Building height
T.Building.h <- 3

# Air change rate [h-1]
T.Building.AirCRate <- 0.5

# Internal temperature [°C]
T.Building.Ti <- 20

# Internal heat emissions [W/m²]
T.Building.qi <- 5

# Ob = Building orientation
T.Building.Orientation <- 0

# StorageCapacity
#1 --> ? for light buildings:15 Wh/(sqm K) * Ve
#2 --> ? for heavy buildings: 50 Wh/(sqm K) * Ve
T.Building.StorageCapacity <- 50

# Building roof slope
T.Building.RoofSlope <- 30

## save
save(
  T.General.Name,
  T.General.PlotOption, 
  T.General.PlotName,
  T.Building.Uwb,
  T.Building.Windows, 
  T.Building.UvalW, 
  T.Building.UvalR, 
  T.Building.UvalWindow, 
  T.Building.Dim,
  T.Building.h,
  T.Building.AirCRate, 
  T.Building.Ti,
  T.Building.qi,
  T.Building.Orientation, 
  T.Building.StorageCapacity, 
  T.Building.RoofSlope,
  file = "./Data/BuildingData")