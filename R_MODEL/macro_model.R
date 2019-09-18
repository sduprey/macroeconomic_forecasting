############## Trying a prediction for the next year for our standard macro model
my_total_df <- readRDS("my_dj_gdp_monthly_sp500_sentiment_macro_total_df.rds") 
# my_total_df <- my_total_df[my_total_df$DATES >= "2003-01-01",]
my_macro_model_data <- my_total_df[c("rUNEMP","rCONS","rCPI","rDEF","rGCE","rGDP","rHOURS","rINV","rM1","rM2","rWAGES","rFED","rG10","rTB3","rSP500")]  
d.vselect <- VARselect(my_macro_model_data, lag.max = 5, type = 'const')$selection[1]
print(d.vselect)
## AIC(n) 
##      5
d.var <- VAR(my_macro_model_data, p = d.vselect, type = 'const')
my_year_prediction <- predict(d.var, n.ahead = 4)
par(mar = rep(2, 4))
plot(my_year_prediction)