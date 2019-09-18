####### Data visualization
# loading the previously saved data frames
my_total_df <-
  readRDS("my_dj_gdp_monthly_sp500_sentiment_macro_total_df.rds")
# initial margin set up
pardefault <- par()
par(pardefault)
##### Plotting GDP and Investment together
inv_gdp_df <- my_total_df[c("DATES","rINV","rGDP")]
inv_gdp_df <- melt(inv_gdp_df,"DATES")
my_title <- "Investment and Output"
p_gdp_inv <-
  ggplot(inv_gdp_df,aes(
    x = DATES,y = value,group = variable,color = variable
  )) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))
##### Plotting Inflation and GDP deflator
cpi_def_df <- my_total_df[c("DATES","rCPI","rDEF")]
cpi_def_df <- melt(cpi_def_df,"DATES")
my_title <- "Inflation and GDP deflator"
p_cpi_def <-
  ggplot(cpi_def_df,aes(
    x = DATES,y = value,group = variable,color = variable
  )) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

#### Plotting consumption and govenrment consumption expenditure
cons_gce_df <- my_total_df[c("DATES","rCONS","rGCE")]
cons_gce_df <- melt(cons_gce_df,"DATES")
my_title <- "Consumption and government expenditures"
p_cons_gce <-
  ggplot(cons_gce_df,aes(
    x = DATES,y = value,group = variable,color = variable
  )) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

#### Plotting consumption and govenrment consumption expenditure
wages_hour_df <- my_total_df[c("DATES","rWAGES","rHOURS")]
wages_hour_df <- melt(wages_hour_df,"DATES")
my_title <- "Wages and hours"
p_wages_hour <-
  ggplot(wages_hour_df,aes(
    x = DATES,y = value,group = variable,color = variable
  )) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

#### Plotting short middle and long term interest rates
rates_df <- my_total_df[c("DATES","rTB3","rG10","rFED")]
rates_df <- melt(rates_df,"DATES")
my_title <- "Interest Rates"
p_rates <-
  ggplot(rates_df,aes(
    x = DATES,y = value,group = variable,color = variable
  )) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

#### Plotting unemployment
my_title <- "Unemployment"
p_unempl <- ggplot(my_total_df, aes(x = DATES, y = rUNEMP)) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

#### Plotting "environment" "politics"    "society"   sentiment together
sentiment_df <- my_total_df[c("DATES","rSENT")]

my_title <- "Ravenpack sentiment"
p_sent <-
  ggplot(sentiment_df,aes(
    x = DATES,y = rSENT
  )) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

sp500_df <- my_total_df[c("DATES","rSP500")]
my_title <- "S&P 500"
p_sp500 <-
  ggplot(sp500_df,aes(
    x = DATES,y = rSP500
  )) +
  geom_line() +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))


### Getting bigger margins to plot
par(mar = rep(2, 4))
multiplot(
  p_gdp_inv, p_cpi_def, p_cons_gce, p_wages_hour, p_rates, p_unempl, p_sent,p_sp500, cols =
    2
)