# Monthly heat balance and annual energy demand of buildings
Energy_CalculatoR <- function(
  General.Name = "No Name", 
  General.PlotOption = FALSE, 
  General.PlotName = "No Name",
  Building.Uwb = FALSE, 
  Building.Windows = FALSE,                           
  Building.UvalW = FALSE, 
  Building.UvalR = FALSE, 
  Building.UvalWindow = FALSE,                           
  Building.Dim = c(FALSE,FALSE), 
  Building.h = FALSE, 
  Building.AirCRate = FALSE, 
  Building.Ti = FALSE, 
  Building.qi = FALSE, 
  Building.Orientation = FALSE, 
  Building.StorageCapacity = FALSE, 
  Building.RoofSlope = FALSE,
  Output.Type = "Year")
  {
  ## input data:
  
  ##################
  # (1) as function of
  ##################
  # Separate module for building data see "Data/GeometryModule.r"
  # (A) General
  #------------------------------------------------------------
  # Name              Char   	    Name of the typ + F
  # PlotOption 	      Boolean 	  Plot figure?
  # PlotName          Name        Name to save plot
  # (B) Building data:
  #------------------------------------------------------------
  # Uwb               Double		  correction value for thermal bridges
  # Windows           Double 		  Percentage of facade with windows      
  # UvalW             Double 		  U-value for walls                 
  # UvalR             Double 		  U-value for Roof                    
  # UvalWindow 	      Double 		  U-value for Window                   
  # Dim               1x2 Double 	Building dimensions L x B	
  # h                 Double 		  Height of Building			
  # AirCRate          Double 		  air change rate [h-1] 		
  # Ti                1x12 Double	Ti(Theta i) internal temperature 
  # qi                Double 		  internal heat emissions.		
  # Ob                Double 		Building orientation               
  # RoofSlope         Double 		Slope of building roof              
  # StorageCapacity   Double    Storage capacity of Building 		
  load("./Data/BuildingData")
  
  # uncomment this line for de-bug
  #load("./Data/BuildingDataDBug")
  #Building.Orientation <- 1
  
  ## Check input data
  if (General.Name        == "No Name") {General.Name        <- T.General.Name} 
  if (General.PlotOption  == FALSE)     {General.PlotOption  <- T.General.PlotOption} 
  if (General.PlotName    == "No Name") {General.PlotName    <- T.General.PlotName}
  if (Building.Uwb        == FALSE)     {Building.Uwb        <- T.Building.Uwb}
  if (Building.Windows    == FALSE)     {Building.Windows    <- T.Building.Windows}                           
  if (Building.UvalW      == FALSE)     {Building.UvalW      <- T.Building.UvalW}
  if (Building.UvalR      == FALSE)     {Building.UvalR      <- T.Building.UvalR}
  if (Building.UvalWindow == FALSE)     {Building.UvalWindow <- T.Building.UvalWindow}                           
  if (Building.Dim[1]     == FALSE)     {Building.Dim        <- T.Building.Dim}
  if (Building.h          == FALSE)     {Building.h          <- T.Building.h}
  if (Building.AirCRate   == FALSE)     {Building.AirCRate   <- T.Building.AirCRate} 
  if (Building.Ti         == FALSE)     {Building.Ti         <- T.Building.Ti}
  if (Building.qi         == FALSE)     {Building.qi         <- T.Building.qi}
  if (Building.Orientation     == FALSE){Building.Orientation<- T.Building.Orientation} 
  if (Building.StorageCapacity == FALSE){Building.StorageCapacity<-T.Building.StorageCapacity}
  if (Building.RoofSlope       == FALSE){Building.RoofSlope  <- T.Building.RoofSlope}
  
  ##################
  # (2) Imported Data <load>
  ##################
  ##Climate:
  # Separate module for climate calculation see "Data/ClimateModule.r"
  load("./Data/ClimateData")
  # I 		  4x12 Double 	Isolation level orientation x months 	
  # Month 	1x12 Double 	Month number				
  # Te 		  1x12 Double 	outside temperature 		
  # t 		  1x12 Double 	days of the month 		
  
  ## output data:
  # Qhs  --> Specific heat demand
  # Hts  --> Specific transmission losses
  
  ## Solar radiation matrix
  # is is easier to change the radiation values that to rotate the building :)
  if (
    Building.Orientation == 0 || 
    Building.Orientation == 180 || 
    Building.Orientation == 360
    ){
    new.Orientation <- c("north", "west", "south","east")
    temp.rectangular <- TRUE
  } else if (
    Building.Orientation == 90 ||
    Building.Orientation == 270
    ){
    new.Orientation <- c("west", "south","east","north")
    temp.rectangular <- TRUE
  } else if (
    Building.Orientation > 0 &&
    Building.Orientation < 90
    ){
    temp.b <- (Building.Orientation-0)/90
    new.Orientation <- data.frame(A=c("north","west","south","east"), 
                                  B=c("west","south","east","north" ))
    temp.rectangular <- FALSE
  } else if (
    Building.Orientation > 90 &&
    Building.Orientation < 180
    ){
    temp.b <- (Building.Orientation-90)/90
    new.Orientation <- data.frame(A=c("west","south","east","north"), 
                                  B=c("south","east","north","west"))
    temp.rectangular <- FALSE
  } else if (
    Building.Orientation > 180 &&
    Building.Orientation < 270
    ){
    temp.b <- (Building.Orientation-180)/90
    new.Orientation <- data.frame(A=c("south","east","north","west"), 
                                  B=c("east","north","west","south"))
    temp.rectangular <- FALSE
  } else if (
    Building.Orientation > 270 &&
    Building.Orientation < 360
    ){
    temp.b <- (Building.Orientation-270)/90
    new.Orientation <- data.frame(A=c("east","north","west","south"), 
                                  B=c("north","west","south","east"))
    temp.rectangular <- FALSE
  }

  #                        (1)N
  #                        ^              7
  #                        |             /
  #                        |            /
  #                       90°          /
  #                        |          /
  #                        |         /
  #                        |        /
  #                        |       /
  #                        |      /   <
  #     (II)    (     x1---|-----x     )   (I)
  #              >    |    |    /4
  #                   |    |   / |
  #                   |    |  /  |    
  #                   |    | /   |     
  #                   |    |/    |
  # (1)W <--180°------|----+-----|--------------0°---> (1)E
  #                   |    |     |
  #                   2    |     |
  #     (III)         x----|----3x         (IV)
  #                        |   
  #                        |   1) Building.Orientation = 0 || 180 || 360
  #                        |      N-W-S-E
  #                        |   2) Building.Orientation = 90 || 270
  #                        |      W-S-E-N
  #                        |   3) Building.Orientation = 1   - 89  (I  )
  #                      270°     NW-SW-SE-NE
  #                        |   4) Building.Orientation = 91  - 179 (II )
  #                        v      SW-SE-NE-NW
  #                     (1)S   5) Building.Orientation = 181 - 269 (III)
  #                               SE-NE-NW-SW
  #                            6) Building.Orientation = 271 - 359 (IV )
  #                               NE-NW-SW-SE
  
  if (temp.rectangular == TRUE){
    colnames(Climate.I) <- new.Orientation
  } else {
    temp.val <- matrix(rep(0,48),nrow=12,ncol=4)
    for (i in 1:4) {
      temp.Pos <- grep(paste("^",new.Orientation$A[i],"$",sep=""), colnames(Climate.I))
      temp.A <- Climate.I[temp.Pos]
      temp.Pos <- grep(paste("^",new.Orientation$B[i],"$",sep=""), colnames(Climate.I))
      temp.B <- Climate.I[temp.Pos]
      temp.val[,i] = unlist(temp.A*(1-temp.b) + temp.B*temp.b)
    }
    Climate.I <- as.data.frame(temp.val)
    colnames(Climate.I) <- c("north", "west", "south","east")
  }
  
  ##################
  ## Heat gains Qg
  ##################
  
  ##internal gains Si
  # heated area An
  Building.An <- Building.Dim[1]*Building.Dim[2]*Building.h/3
  Heat.gains.Si <- Building.qi * Building.An
  
  ##monthly solar heat flows Ss
  # Ss(M) average monthly solar heat flow [W]
  # I(M,j) average solar intensity of radiation [W/m²]
  # A(s,j) actual collector surface [m²]
  # J orientation (direction and down-grade to vertical)
  Heat.gains.Ss <-
  Climate.I$north*(Building.Dim[1]*Building.h*Building.Windows) +
  Climate.I$west *(Building.Dim[2]*Building.h*Building.Windows) +
  Climate.I$south*(Building.Dim[1]*Building.h*Building.Windows) +
  Climate.I$east *(Building.Dim[2]*Building.h*Building.Windows)
  
  ##Heat gains Qg
  #0,024 kWh = 1 Wd
  #Ss(M) average monthly solar heat flow [W]
  #Si(M) heat flow by internal heat sources [W]
  #t(M) number of the days in a particular month [d/M]
  Heat.gains.Qg <- 0.024 * (Heat.gains.Ss + Heat.gains.Si) * Climate.t
  
  ##################
  ## Heat losses Ql
  ##################
  
  ##ventilation loss Hv !! Only for natural ventilation
  # AirCRate = air change rate [h-1]
  # V volume of air in heated building (according to EnEV it obtains V = 0,8* Ve)
  # pL* CPL heat storage capacity of air = 0,34 [Wh/(m²K)]
  Building.Ve <- Building.Dim[1]*Building.Dim[2]*Building.h
  Building.V <- 0.8 * Building.Ve
  Constant.plCpl = 0.34
  Heat.loss.Hv <- Building.AirCRate * Building.V * Constant.plCpl;
  
  ##thermal bridge addition
  # Uwb correction value for thermal bridges [W/m²K]
  # A total heat transmitting building envelope [m²]
  Building.A.Roof  <- 2*(Building.Dim[2]*((Building.Dim[1]/2)/cos(Building.RoofSlope*pi/180)))
  Building.A.Wall.1 <- Building.Dim[1]*Building.h
  Building.A.Wall.2 <- Building.Dim[2]*Building.h
  Building.A.Window <- Building.A.Wall.1 * Building.Windows * 2 + Building.A.Wall.2 * Building.Windows * 2
  # Building.A.Slab = Building.Dim[1] * Building.Dim[2]
  Building.A <- 2*Building.A.Wall.1 + 2*Building.A.Wall.2 + Building.A.Roof
  Heat.loss.Hwb <- Building.Uwb * Building.A
  
  ##transmission losses Ht
  # Temperature correction factor Fx
  # Ti(Theta i) internal temperature [K]
  # Tu(M) Temperature in unheated space [K]
  # Te(M) Ambient (=external) temperature [K]
  
  # Fx(M) = (Ti-Tu(M))/(Ti-Te(M)) integrated in Area Calculator module
  # Heat losses referring to heat loss surface Hu
  # U(i) Heat transfer coefficient [W/(m²K)]
  # A(i) Analogical to building part surface [m²]
  # Fx(i) Temperature correction factor
  
  # Hu(i) = Fx * U * (integrated in Htu)
  Heat.loss.Hu <- 0
  
  # Htfh Not consider in these calculation.
  Heat.loss.Htfh <- 0
  
  # Ls Not consider in these calculation. integrated in Htu
  Heat.loss.Ls <- 0
  
  ##transmission losses Ht
  # U(i) Heat transfer coefficient incountercurrent with ambient air[W/(sqm K)]
  # A(i) Analogical to building part surface [sqm]
  # Hu Heat losses referring to heat loss surface [W/K]
  # Ls thermal guide value for ground bordering surfaces [W/K]
  # Hwb thermal bridges addition [W/K]
  # Htfh Specific transmission heat loss by building parts with integrated panel heating [W/K]
  # Ht = sum (U) * sum (A) + Hu + Ls + Hwb + Htfh
  Heat.loss.Htu <-
    (((2*Building.A.Wall.1*(1-Building.Windows) + 
       2*Building.A.Wall.2*(1-Building.Windows))) * 
       Building.UvalW) + 
    (Building.A.Roof * Building.UvalR) + 
    (Building.A.Window * Building.UvalWindow)
  Heat.loss.Ht <- Heat.loss.Htu + Heat.loss.Hu + Heat.loss.Ls + Heat.loss.Hwb + Heat.loss.Htfh
  
  #specific total heat loss (transmission and ventilation heat losses;HT+HV) [W/K] H
  Heat.loss.H <- Heat.loss.Ht + Heat.loss.Hv
  
  ##Heat losses Ql
  # 0,024 kWh = 1 Wd
  # H(M) specific total heat loss (transmission and ventilation heat losses;HT+HV) [W/K]
  # Ti-Te(M) difference between internal and ambient temperature [K]
  # t(M) number of the days in a particular month [d/M]
  Heat.loss.Ql <- 0.024 * Heat.loss.H * (Building.Ti - Climate.Te) * Climate.t
  
  ##################
  ## Monthly heat demand Qh
  ##################
  
  # Ql(M) sum of monthly heat loss due to transmission and ventilation [kWh/M]
  # Qg(M) sum of monthly heat gains [kWh/M]
  # n(M) monthly utilization factor for the gains [-]
  Heat.demand.Thermal = Building.StorageCapacity * Building.Ve / Heat.loss.H
  Heat.demand.a = 1 + Heat.demand.Thermal/16
  Heat.demand.y <- Heat.gains.Qg/Heat.loss.Ql
  
  Heat.demand.Qhm <- rep(0,12)
  for (m in 1:12) {
    if (Heat.demand.y[m] == 1 ){
      Heat.demand.n <- (Heat.demand.a / (Heat.demand.a +1))
    } else {
      Heat.demand.n <- (1-Heat.demand.y[m]^Heat.demand.a)/(1-Heat.demand.y[m]^(Heat.demand.a+1))
    }
    Heat.demand.Qhm[m] <- Heat.loss.Ql[m] - Heat.demand.n * Heat.gains.Qg[m]
  }
  
  # subtraction of negative heat demand
  Heat.demand.Qhm[Heat.demand.Qhm < 0] <- 0
  Heat.demand.Qh <- sum(Heat.demand.Qhm)
  
  ## Specific heat demand [kWh/sqm a] Qhs 
  #  and specific transmission losses Hts [W/sqm K]
  Heat.demand.Qhs = Heat.demand.Qh / Building.An
  Heat.demand.Hts = Heat.loss.Ht / Building.An

  ## Sum of solar heat gains
  Heat.gains.Ss.sum <- sum(Heat.gains.Ss)
  ## Total Irradiation
  Total.Irradiation <- sum(Climate.I)
  
  ## Result
  if (Output.Type == "Year"){
    result = data.frame(
      Ti = Total.Irradiation,
      Ss = Heat.gains.Ss.sum, 
      Qhs = Heat.demand.Qhs, 
      Hts = Heat.demand.Hts)
  } else if (Output.Type == "Month"){
    result = data.frame(
      Qhm = Heat.demand.Qhm)
  }
  return(result)
}
