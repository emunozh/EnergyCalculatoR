# This example shows how to use the function with a
# for loop. 
# This example show the heat demand variation for different
# U values combinations

# Set the proper working directory
setwd("~/workspace/R/Energy_Calculator_Munoz")

# Load local functions
source("./Energy_CalculatoR.r")

Buildings.Number <- 9

U.Values <- matrix(c(
  1.3,  1.0,	3.0,    # 01
  1.2,	0.9,	2.7,    # 02
  1.1,	0.8,	2.7,    # 03
  1.0,	0.7,	2.7,    # 04
  0.9,	0.6,	2.4,    # 05
  0.8,	0.5,	2.1,    # 06
  0.6,	0.4,	1.9,    # 07
  0.5,	0.3,	1.6,    # 08
  0.4,	0.2,	1.6),   # 09
  3,Buildings.Number)

Heat.Demand <- rep(0,Buildings.Number)
for (i in 1:Buildings.Number){
  UvalW <- U.Values[1,i]
  UvalR <- U.Values[2,i]
  UvalWindow <- U.Values[3,i]
  temp.2 <- Energy_CalculatoR(Building.UvalW = UvalW, 
                              Building.UvalR = UvalR, 
                              Building.UvalWindow = UvalWindow)
  Heat.Demand[i] <- temp.2$Qhs
}

# bar plot
barplot(Heat.Demand,
        names.arg = seq(1910,2010,12),
        main = "Heat demand for a set of buildings",
        ylab = "Heat demand [kWh/m²a]",
        xlab = "Building age")
