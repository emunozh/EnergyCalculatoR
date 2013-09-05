# This example shows how to use the function with a
# for loop. 
# you will need to install ggplot in order to run this 
# example --> install.packages("ggplot2") 
# This example show the heat demand variation for different
# Building orientations

# Set the proper working directory
setwd("~/workspace/R/Energy_Calculator_Munoz")

# Load local functions
source("./Energy_Calculator.r")

iter <- seq(0,360,1)
#iter <- c(0,90,180,270,360)
Heat.Demand = rep(0,length(iter))
Heat.Gains.Solar = rep(0,length(iter))
Irradiation.Sum = rep(0,length(iter))

for (i in 1:length(iter)){
  BO <- iter[i]
  temp.2 <- Energy_Calculator(Building.Orientation = BO)
  Heat.Demand[i] <- temp.2$Qhs
  Heat.Gains.Solar[i] <- temp.2$Ss
  Irradiation.Sum[i] <- temp.2$Ti
}

# Polar plot + line plot
result <- data.frame(heat.demand = Heat.Demand,
                     orientation = iter)
doh <- ggplot(result, aes(orientation, heat.demand))
# Line plot
doh + geom_line(colour = "red", size = 1)  + 
  coord_polar() +
  labs(title = "Heat demand for all posible building orientations")