# This example shows how to use the function with a
# for loop. 
# This example show the heat demand variation for different
# user influenced parameters

# Set the proper working directory
setwd("~/workspace/R/Energy_Calculator_Munoz")

# Load local functions
source("./Energy_CalculatoR.r")

Buildings.Number <- 5

Param.Values <- matrix(c(
7, 22, 0.7,   # 01
6, 21, 0.6,   # 02
5, 20, 0.5,   # 03
4, 19, 0.4,   # 04
3, 18, 0.3),  # 05
      3,Buildings.Number)

UvalW <- 0.4
UvalR <- 0.2
UvalWindow <- 1.6

# UvalW <- 1.3
# UvalR <- 1.0
# UvalWindow <- 3.0

Heat.Demand <- rep(0,Buildings.Number)
for (i in 1:Buildings.Number){
  AirCRate <- Param.Values[1,i]
  Ti <- Param.Values[2,i]
  qi <- Param.Values[3,i]
  temp.2 <- Energy_CalculatoR(Building.AirCRate = AirCRate, 
                              Building.Ti = Ti, 
                              Building.qi = qi,
                              Building.UvalW = UvalW, 
                              Building.UvalR = UvalR, 
                              Building.UvalWindow = UvalWindow)
  Heat.Demand[i] <- temp.2$Qhs
}

# bar plot
barplot(Heat.Demand,
        main = "Heat demand for a set of buildings",
        ylab = "Heat demand [kWh/m²a]",
        xlab = "Building age")

