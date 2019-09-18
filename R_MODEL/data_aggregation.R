####### Data aggregation
#SP500 <- readRDS(paste(inputDataPath,"SP500.rds",sep=""))
SP500 <- readRDS("SP500.rds")

# Merging sentiment and macro economic data on a monthly basis
## Cubic spline interpolation for getting week end days SP 500
## 1 month equally weigthed Moving average Sentiment per Ravenpack macro group
DateSeq <- seq(tail(SP500$Date,1),SP500$Date[1],by ="1 day")
rSP500 = zoo(spline(SP500, method = "natural", xout = DateSeq)$y)
rSP500 <- rSP500/lag(rSP500, -1, na.pad = TRUE)-1

my_interpolated_SP500 <- data.frame(DATES = DateSeq, rSP500 = rSP500)
### getting the SP500 monthly return

# loading the previously saved data frames for macro economic data
#my_final_df <-
#  readRDS(paste(outputDataPath,"my_final_mdf.rds", sep = ""))
my_final_df <- readRDS("my_final_mdf.rds", sep = "")

###### Merging SP500
my_merged_df <-merge(x=my_final_df, y=my_interpolated_SP500, by ='DATES', all.x = TRUE)

saveRDS(my_merged_df, file = "my_dj_gdp_monthly_sp500_sentiment_macro_total_df.rds")

