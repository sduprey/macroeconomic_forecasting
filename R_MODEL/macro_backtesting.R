### Backtesting our standard macro model


my_total_df <-
  readRDS("my_dj_gdp_monthly_sp500_sentiment_macro_total_df.rds")
my_variables <-
  c(
    "rUNEMP","rCONS","rCPI","rDEF","rGCE","rGDP","rHOURS","rINV","rM1","rM2","rWAGES","rFED","rG10","rTB3","rSP500"
  )


start_date <- "2006-01-01"
end_date <- "2019-04-01"


my_model_data <- my_total_df[my_variables]

backtesting_dates_logical_index <-
  (my_total_df$DATES >= start_date &
     my_total_df$DATES <= end_date)
backtesting_dates_index <-
  which(backtesting_dates_logical_index == TRUE)
d.vselect <-
  VARselect(my_model_data, lag.max = 2, type = 'const')$selection[1]
nb_iteration <- sum(backtesting_dates_logical_index)

backtesting_predictions <-
  matrix(0,nrow = nb_iteration, ncol = length(my_variables))
backtesting_lowerbounds <-
  matrix(0,nrow = nb_iteration, ncol = length(my_variables))
backtesting_upperbounds <-
  matrix(0,nrow = nb_iteration, ncol = length(my_variables))

for (i in 1:nb_iteration) {
  model_calibrating_data <-
    my_total_df[1:backtesting_dates_index[i],my_variables]
  d.var <-
    VAR(model_calibrating_data, p = d.vselect, type = 'const')
  my_quarter_prediction <- predict(d.var, n.ahead = 1)
  backtesting_predictions[i,] <-
    unlist(lapply(my_variables, function(x) {
      my_quarter_prediction$fcst[[x]][,1]
    }))
  backtesting_lowerbounds[i,] <-
    unlist(lapply(my_variables, function(x) {
      my_quarter_prediction$fcst[[x]][,2]
    }))
  backtesting_upperbounds[i,] <-
    unlist(lapply(my_variables, function(x) {
      my_quarter_prediction$fcst[[x]][,3]
    }))
}

#### Plotting the prediction of our sentiment_enhanced_model

my_happened_df <- my_total_df[backtesting_dates_logical_index,]

colnames(backtesting_predictions) <-
  paste(my_variables, "_PRED",sep = "")
rownames(backtesting_predictions) <- my_happened_df$DATES
backtesting_predictions <- as.data.frame(backtesting_predictions)


colnames(backtesting_upperbounds) <- paste(my_variables, "_UP",sep = "")
rownames(backtesting_upperbounds) <- my_happened_df$DATES
backtesting_upperbounds <- as.data.frame(backtesting_upperbounds)

colnames(backtesting_lowerbounds) <-
  paste(my_variables, "_DOWN",sep = "")
rownames(backtesting_lowerbounds) <- my_happened_df$DATES
backtesting_lowerbounds <- as.data.frame(backtesting_lowerbounds)

mbacktesting_results_df <-
  cbind(
    my_happened_df,backtesting_predictions,backtesting_lowerbounds,backtesting_upperbounds
  )
############ Computing the observation averaged RMSE for some significant macro variables
#### Getting the same unpercentaged value
mbacktesting_results_df$rUNEMP_RMSE <-
  (mbacktesting_results_df$rUNEMP - mbacktesting_results_df$rUNEMP_PRED) ^
  2
mbacktesting_results_df$rCONS_RMSE <-
  (mbacktesting_results_df$rCONS - mbacktesting_results_df$rCONS_PRED) ^
  2
mbacktesting_results_df$rCPI_RMSE <-
  (mbacktesting_results_df$rCPI - mbacktesting_results_df$rCPI_PRED) ^ 2
mbacktesting_results_df$rDEF_RMSE <-
  (mbacktesting_results_df$rDEF - mbacktesting_results_df$rDEF_PRED) ^ 2
mbacktesting_results_df$rGCE_RMSE <-
  (mbacktesting_results_df$rGCE - mbacktesting_results_df$rGCE_PRED) ^ 2
mbacktesting_results_df$rGDP_RMSE <-
  (mbacktesting_results_df$rGDP - mbacktesting_results_df$rGDP_PRED) ^ 2
mbacktesting_results_df$rHOURS_RMSE <-
  (mbacktesting_results_df$rHOURS - mbacktesting_results_df$rHOURS_PRED) ^
  2
mbacktesting_results_df$rINV_RMSE <-
  (mbacktesting_results_df$rINV - mbacktesting_results_df$rINV_PRED) ^ 2
mbacktesting_results_df$rM1_RMSE <-
  (mbacktesting_results_df$rM1 - mbacktesting_results_df$rM1_PRED) ^ 2
mbacktesting_results_df$rM2_RMSE <-
  (mbacktesting_results_df$rM2 - mbacktesting_results_df$rM2_PRED) ^ 2
mbacktesting_results_df$rWAGES_RMSE <-
  (mbacktesting_results_df$rWAGES - mbacktesting_results_df$rWAGES_PRED) ^
  2
mbacktesting_results_df$rFED_RMSE <-
  (mbacktesting_results_df$rFED - mbacktesting_results_df$rFED_PRED) ^ 2
mbacktesting_results_df$rG10_RMSE <-
  (mbacktesting_results_df$rG10 - mbacktesting_results_df$rG10_PRED) ^ 2
mbacktesting_results_df$rTB3_RMSE <-
  (mbacktesting_results_df$rTB3 - mbacktesting_results_df$rTB3_PRED) ^ 2

#mbacktesting_results_df$RMSE <-
#  vec_square_diff_rmse(mbacktesting_results_df)

mbacktesting_results_df$rUNEMP_NORM_RMSE <-
  (mbacktesting_results_df$rUNEMP) ^ 2
mbacktesting_results_df$rCONS_NORM_RMSE <-
  (mbacktesting_results_df$rCONS) ^ 2
mbacktesting_results_df$rCPI_NORM_RMSE <-
  (mbacktesting_results_df$rCPI) ^ 2
mbacktesting_results_df$rDEF_NORM_RMSE <-
  (mbacktesting_results_df$rDEF) ^ 2
mbacktesting_results_df$rGCE_NORM_RMSE <-
  (mbacktesting_results_df$rGCE) ^ 2
mbacktesting_results_df$rGDP_NORM_RMSE <-
  (mbacktesting_results_df$rGDP) ^ 2
mbacktesting_results_df$rHOURS_NORM_RMSE <-
  (mbacktesting_results_df$rHOURS) ^ 2
mbacktesting_results_df$rINV_NORM_RMSE <-
  (mbacktesting_results_df$rINV) ^ 2
mbacktesting_results_df$rM1_NORM_RMSE <-
  (mbacktesting_results_df$rM1) ^ 2
mbacktesting_results_df$rM2_NORM_RMSE <-
  (mbacktesting_results_df$rM2) ^ 2
mbacktesting_results_df$rWAGES_NORM_RMSE <-
  (mbacktesting_results_df$rWAGES) ^ 2
mbacktesting_results_df$rFED_NORM_RMSE <-
  (mbacktesting_results_df$rFED) ^ 2
mbacktesting_results_df$rG10_NORM_RMSE <-
  (mbacktesting_results_df$rG10) ^ 2
mbacktesting_results_df$rTB3_NORM_RMSE <-
  (mbacktesting_results_df$rTB3) ^ 2

#mbacktesting_results_df$NORM_RMSE <-
#  vec_norm_rmse(mbacktesting_results_df)


#mbacktesting_results_df$L1_NORM <-
#  vec_l1_norm_rmse(mbacktesting_results_df)
#mbacktesting_results_df$ERROR <-
#  vec_diff_rmse(mbacktesting_results_df)
#mbacktesting_results_df$GLOBAL_PERCENT_ERROR <-
#  mbacktesting_results_df$ERROR / mbacktesting_results_df$L1_NORM

mbacktesting_results_df$L1_NORM_GDP <-
  abs(mbacktesting_results_df$rGDP)
mbacktesting_results_df$ERROR_GDP <-
  abs(mbacktesting_results_df$rGDP - mbacktesting_results_df$rGDP_PRED)
mbacktesting_results_df$GDP_PERCENT_ERROR <-
  mbacktesting_results_df$ERROR_GDP / mbacktesting_results_df$L1_NORM_GDP

##### Displaying the computed averaged RMSE
saveRDS(mbacktesting_results_df, file = "m_dj_gdp_sp500_macro_backtesting_results_df.rds")


##### Displaying the computed averaged RMSE
my_gdp_rmse <- sqrt(sum(mbacktesting_results_df$rGDP_RMSE,na.rm = T ))/sum(!is.nan(abs(mbacktesting_results_df$rGDP_RMSE)))

my_rmse_perc <-
  sqrt(sum(mbacktesting_results_df$RMSE,na.rm = T)) / (sqrt(sum(
    mbacktesting_results_df$NORM_RMSE,na.rm = T
  )) * sum(!is.nan(mbacktesting_results_df$RMSE)))

print("My global RMSE percentage : ")
## [1] "My global RMSE percentage : "
print(my_rmse_perc)
## [1] 0.004782696
print("My GDP RMSE percentage : ")
## [1] "My GDP RMSE percentage : "
print(my_gdp_rmse)
## [1] 0.0004024684