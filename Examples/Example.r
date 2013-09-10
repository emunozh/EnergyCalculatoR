# This example shows a simple use of the function
# Output monthly heat demand

# Set the proper working directory
setwd("~/workspace/R/Energy_Calculator_Munoz")

# Load local functions
source("./Energy_CalculatoR.r")
Climate.MonthsNames <- c("January","February","March","April",
                         "May","June","July","August",
                         "September","October","November","December")

temp.1 <- Energy_CalculatoR(Building.Orientation = 0,
                            Output.Type = "Month")
Qhm <- temp.1$Qhm
barplot(Qhm,
        names.arg=Climate.MonthsNames,
        main = "Monthly Heat Demand",
        ylab =  "head Demand [kWh]")
