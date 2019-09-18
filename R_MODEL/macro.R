require(Quandl)
require(zoo)
require(xts)
require(ggplot2)
require(reshape2)
require(vars)
require(plyr)
require(TTR)
library("lubridate")

###### Getting macro economic data from Quandl API
##### Getting data from the federal reserve

COE = Quandl("FRED/COE", start_date = "1960-01-01",end_date = "2015-08-01",type ="xts")
CPIAUCSL = Quandl(
  "FRED/CPIAUCSL", start_date = "1960-01-01",end_date = "2015-08-01",type =
    "xts"
)
FEDFUNDS = Quandl(
  "FRED/FEDFUNDS", start_date = "1960-01-01",end_date = "2015-08-01",type =
    "xts"
)
GCE = Quandl("FRED/GCE", start_date = "1960-01-01",end_date = "2015-08-01",type =
               "xts")
GDP = Quandl("FRED/GDP", start_date = "1960-01-01",end_date = "2015-08-01",type =
               "xts")
GDPDEF = Quandl(
  "FRED/GDPDEF", start_date = "1960-01-01",end_date = "2015-08-01",type =
    "xts"
)
GPDI = Quandl(
  "FRED/GPDI", start_date = "1960-01-01",end_date = "2015-08-01",type = "xts"
)
GS10 = Quandl(
  "FRED/GS10", start_date = "1960-01-01",end_date = "2015-08-01",type = "xts"
)
HOANBS = Quandl(
  "FRED/HOANBS", start_date = "1960-01-01",end_date = "2015-08-01",type =
    "xts"
)
M1SL = Quandl(
  "FRED/M1SL", start_date = "1960-01-01",end_date = "2015-08-01",type = "xts"
)
M2SL = Quandl(
  "FRED/M2SL", start_date = "1960-01-01",end_date = "2015-08-01",type = "xts"
)
PCEC = Quandl(
  "FRED/PCEC", start_date = "1960-01-01",end_date = "2015-08-01",type = "xts"
)
TB3MS = Quandl(
  "FRED/TB3MS", start_date = "1960-01-01",end_date = "2015-08-01",type = "xts"
)
UNRATE = Quandl(
  "FRED/UNRATE", start_date = "1960-01-01",end_date = "2015-08-01",type =
    "xts"
)

#### Getting all quaterly data into a single data frame
my_data <- merge(COE,GCE,join = 'inner')
my_data <- merge(my_data,GDP,join = 'inner')
my_data <- merge(my_data,GDPDEF,join = 'inner')
my_data <- merge(my_data,GPDI,join = 'inner')
my_data <- merge(my_data,HOANBS,join = 'inner')
my_data <- merge(my_data,PCEC,join = 'inner')


data_matrix <-
  matrix(my_data,dim(my_data)[1],dim(my_data)[2],dimnames = list(
    time(my_data),c("COE","GCE","GDP","GDPDEF","GPDI","HOANBS","PCEC")
  ))
my_final_quandl_monthly_df <- as.data.frame(data_matrix)
my_final_quandl_monthly_df$DATES <- as.Date(index(my_data))
#### reordering the columns
my_final_quandl_monthly_df <-
  my_final_quandl_monthly_df[c("DATES","COE","GCE","GDP","GDPDEF","GPDI","HOANBS","PCEC")]

#### We turn quaterly series to monthly series
#### cubic spline interpolation
my_coe_df <- my_final_quandl_monthly_df[c("DATES","COE")]
my_gce_df <- my_final_quandl_monthly_df[c("DATES","GCE")]
my_gdp_df <- my_final_quandl_monthly_df[c("DATES","GDP")]
my_gdpdef_df <- my_final_quandl_monthly_df[c("DATES","GDPDEF")]
my_gpdi_df <- my_final_quandl_monthly_df[c("DATES","GPDI")]
my_hoanbs_df <- my_final_quandl_monthly_df[c("DATES","HOANBS")]
my_pcec_df <- my_final_quandl_monthly_df[c("DATES","PCEC")]

DateSeq <-
  seq(my_final_quandl_monthly_df$DATES[1],tail(my_final_quandl_monthly_df$DATES,1),by =
        "1 month")
my_final_quandl_monthly_df_Monthly <-
  data.frame(
    DATES = DateSeq, COE_M = spline(my_coe_df, method = "natural", xout = DateSeq)$y, GCE_M =
      spline(my_gce_df, method = "natural", xout = DateSeq)$y, GDP_M = spline(my_gdp_df, method =
                                                                                "natural", xout = DateSeq)$y, GDPDEF_M = spline(my_gdpdef_df, method = "natural", xout =
                                                                                                                                  DateSeq)$y, GPDI_M = spline(my_gpdi_df, method = "natural", xout = DateSeq)$y, ANBS_M =
      spline(my_hoanbs_df, method = "natural", xout = DateSeq)$y,  PCEC_M = spline(my_pcec_df, method =
                                                                                     "natural", xout = DateSeq)$y
  )

## Now merging the natural monthly time series into a month data frame
my_mdata <- merge(CPIAUCSL,FEDFUNDS,join = 'inner')
my_mdata <- merge(my_mdata,GS10,join = 'inner')
my_mdata <- merge(my_mdata,M1SL,join = 'inner')
my_mdata <- merge(my_mdata,M2SL,join = 'inner')
my_mdata <- merge(my_mdata,TB3MS,join = 'inner')
my_mdata <- merge(my_mdata,UNRATE,join = 'inner')


mdata_matrix <-
  matrix(my_mdata,dim(my_mdata)[1],dim(my_mdata)[2],dimnames = list(
    time(my_mdata),c(
      "CPIAUCSL","FEDFUNDS","GS10","M1SL","M2SL","TB3MS","UNRATE"
    )
  ))
my_mdf <- as.data.frame(mdata_matrix)
my_mdf$DATES <- as.Date(index(my_mdata))
my_mdf <-
  my_mdf[c("DATES","CPIAUCSL","FEDFUNDS","GS10","M1SL","M2SL","TB3MS","UNRATE")]
my_final_quandl_monthly_df <-
  merge(my_mdf, my_final_quandl_monthly_df_Monthly, by = 'DATES')

colnames(my_final_quandl_monthly_df) <-
  c(
    "DATES","CPIAUCSL","FEDFUNDS","GS10","M1SL","M2SL","TB3MS","UNRATE","COE","GCE","GDP","GDPDEF","GPDI","HOANBS","PCEC"
  )

### Saving our monthly macro data frame
SaveDataFrame(my_final_quandl_monthly_df,outputDataPath,"my_final_quandl_monthly_df")

##### Preprocessing the data to get returns
####### Differencing our series : we model the log return which are stationary
# Log series
CONS = log(my_final_quandl_monthly_df$PCEC)
CPI = log(my_final_quandl_monthly_df$CPIAUCSL)
DEF = log(my_final_quandl_monthly_df$GDPDEF)
GCE = log(my_final_quandl_monthly_df$GCE)
GDP = log(my_final_quandl_monthly_df$GDP)
HOURS = log(my_final_quandl_monthly_df$HOANBS)
INV = log(my_final_quandl_monthly_df$GPDI)
M1 = log(my_final_quandl_monthly_df$M1SL)
M2 = log(my_final_quandl_monthly_df$M2SL)
WAGES = log(my_final_quandl_monthly_df$COE)

#Interest rates(annual)
rFED = 0.01 * (my_final_quandl_monthly_df$FEDFUNDS)
rG10 = 0.01 * (my_final_quandl_monthly_df$GS10)
rTB3 = 0.01 * (my_final_quandl_monthly_df$TB3MS)
#Integrated rates
FED = fromRetToPrices(0.25 * rFED)
FED = log(FED[-1])
G10 = fromRetToPrices(0.25 * rG10)
G10 = log(G10[-1])
TB3 = fromRetToPrices(0.25 * rTB3)
TB3 = log(TB3[-1])

# Unemployment rate
rUNEMP = 0.01 * (my_final_quandl_monthly_df$UNRATE)
UNEMP = fromRetToPrices(0.25 * rUNEMP)
UNEMP = log(UNEMP[-1])

# we initialize with the mean of the four first values
rCONS <- c(4 * mean(diff(CONS[1:5])),4 * diff(CONS))
rCPI <- c(4 * mean(diff(CPI[1:5])),4 * diff(CPI))
rDEF <- c(4 * mean(diff(DEF[1:5])),4 * diff(DEF))
rGCE <- c(4 * mean(diff(GCE[1:5])),4 * diff(GCE))
rGDP <- c(4 * mean(diff(GDP[1:5])),4 * diff(GDP))
rHOURS <- c(4 * mean(diff(HOURS[1:5])),4 * diff(HOURS))
rINV <- c(4 * mean(diff(INV[1:5])),4 * diff(INV))
rM1 <- c(4 * mean(diff(GDP[1:5])),4 * diff(M1))
rM2 <- c(4 * mean(diff(HOURS[1:5])),4 * diff(M2))
rWAGES <- c(4 * mean(diff(INV[1:5])),4 * diff(WAGES))

#### Final data frame to save
my_final_mdf <- data.frame(
  "DATES"  = my_final_quandl_monthly_df$DATES,
  "rUNEMP" = rUNEMP,
  "rCONS" =  rCONS,
  "rCPI" =  rCPI,
  "rDEF" =  rDEF ,
  "rGCE" = rGCE,
  "rGDP" = rGDP,
  "rHOURS" = rHOURS,
  "rINV" =  rINV ,
  "rM1" =  rM1 ,
  "rM2" =  rM2 ,
  "rWAGES" = rWAGES,
  "rFED" = rFED,
  "rG10" = rG10,
  "rTB3" = rTB3
)

my_final_int_mdf <- data.frame(
  "DATES"  = my_final_quandl_monthly_df$DATES,
  "UNEMP" = UNEMP,
  "CONS" =  CONS,
  "CPI" =  CPI,
  "DEF" =  DEF ,
  "GCE" = GCE,
  "GDP" = GDP,
  "HOURS" = HOURS,
  "INV" =  INV ,
  "M1" =  M1 ,
  "M2" = M2 ,
  "WAGES" = WAGES,
  "FED" = FED,
  "G10" = G10,
  "TB3" = TB3
)
## Saving the two finally processed time series
#SaveDataFrame(my_final_mdf,outputDataPath,"my_final_mdf")

saveRDS(my_final_int_mdf, file = "my_final_mdf")

SP500 <- Quandl("YAHOO/INDEX_GSPC", authcode="gustKaxRreyXoTGyMq9D")
saveRDS(my_final_int_mdf, file = "my_final_mdf")

# SaveDataFrame(SP500,inputDataPath,"SP500")
