## Load Data
# this script reads the data form an csv file
# you may change the values in the excel file (Data/Climate.xls)
# and export is as a csv file.

Location.Latitude <- 53.5
Location.City <- "Hamburg"
Climate.MonthsNames <- c("January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December")

ClimateData <- read.csv("./Data/Climate.csv", header = TRUE, sep = ",", 
                        quote = "\"", dec = ".")
rownames(ClimateData) <- c("Days", "north", "west", "south", "east", "Temperature")	
# Month number
Climate.Month <- 1:12
# Days of the month
Climate.t = unlist(ClimateData["Days",])
# Irradiation
Climate.I <- data.frame(t(ClimateData[2:5,]))
# Internal temperature
Climate.Ti <- 20
# External temperature
Climate.Te <- unlist(ClimateData["Temperature",])

save(Location.Latitude, Location.City, Climate.MonthsNames,
     Climate.Te, Climate.I, Climate.t, Climate.Month,
     file = "./Data/ClimateData")

## Plot temperatures
Title = paste("Monthly temperatures for", Location.City, "; Latitude:",Location.Latitude)
barplot(Te, main=Title, xlab="Month", ylab="Temperature [°C]",
        names.arg = Climate.MonthsNames, ylim = c(0,25))
abline(a=Climate.Ti, b=0)

## Plot Irradiation
# get the range for the x and y axis
xrange <- c(1,12)
yrange <- range(Climate.I) 

# set up the plot 
plot(xrange, yrange, type="n", xlab="Months",
     ylab="Irradation [W/m²]" )
colors <- rainbow(4)
linetype <- c(1:4)
plotchar <- seq(18,18+4,1)

orientation <- colnames(Climate.I)
# add lines
for (i in 1:4) {
  n = orientation[i]
  a = unlist(I[i])
  lines(Month, a, type="b", lwd=1.5,
        lty=linetype[i], col=colors[i], pch=plotchar[i])
}

# add a title and subtitle
Title = paste("Irradiation values for", Location.City, "; Latitude:",Location.Latitude)
title(Title)

# add a legend
legend(xrange[1], yrange[2], colnames(I), cex=0.8, col=colors, #legend=colnames(I),
       pch=plotchar, lty=linetype, title="Orientation")