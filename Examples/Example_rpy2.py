#!/usr/bin/env python
#-*- coding:utf -*-
"""
# Created by Esteban #

Mon Sep 09
"""

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

import rpy2.robjects as robjects
robjects.r.setwd("/home/esteban/workspace/R/Energy_Calculator_Munoz")
from rpy2.robjects.packages import importr
import rpy2.robjects.lib.ggplot2 as ggplot2
import numpy as np
from math import pi

# We want to store the plot in a file
grdevices = importr('grDevices')
# working directory
wp = "/home/esteban/workspace/R/\
Energy_Calculator_Munoz"
wd = wp+"/Energy_CalculatoR.r"
grdevices.png(file=wp+"/Examples/rpyggplot.png", width=512, height=512)

# load function
func = open(wd, "r")
src_func = func.read()
robjects.r(src_func)
ECR = robjects.globalenv['Energy_CalculatoR']
# yes, I know reading the function as string is not the best way
# I' still learning rpy2 an alternative would be appreciated!
#TODO: load function as 'source(./Energy_CalculatoR.r)'


heat_demand = np.zeros(37)
Bdim = robjects.FloatVector([12,6])
for i,BO in enumerate(range(0,361,10)):
    res = ECR(Building_Orientation = BO,
                Building_Dim = Bdim)
    heat_demand[i] = res[2][0]

# Transfor to R data types
hd = robjects.FloatVector([h for h in heat_demand])
bo = robjects.FloatVector([b for b in range(0,361,10)])

# Create a python dictionary
p_datadic = {'Heat_Demand': hd,
             'Building_Orientation': bo}

# Create R data.frame
r_dataf = robjects.DataFrame(p_datadic)

# plot with ggplot2
gp = ggplot2.ggplot(r_dataf)
pp = gp + ggplot2.aes_string(y= 'Heat_Demand', x= 'Building_Orientation') + \
     ggplot2.geom_line(colour = "red", size = 1) + \
     ggplot2.coord_polar(direction = -1, start = -pi/2) + \
     ggplot2.ggtitle("Heat demand for all possible buildimg orientations") + \
     ggplot2.scale_x_continuous(breaks=robjects.FloatVector(range(0, 360, 15)))

pp.plot()
grdevices.dev_off()
