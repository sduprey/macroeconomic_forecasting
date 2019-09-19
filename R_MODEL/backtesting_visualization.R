library(ggplot2)
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
########### Visualizing the results of our standard macro model
total_df <-
  readRDS("m_dj_gdp_sp500_macro_backtesting_results_df.rds")
past_twenty_index <- total_df$DATES >= "2006-01-01"
##### UNEMPLOYMENT
rUNEMP_pred_df <-
  total_df[past_twenty_index,c("DATES","rUNEMP","rUNEMP_PRED","rUNEMP_DOWN","rUNEMP_UP")]
rUNEMP_df <- total_df[past_twenty_index,c("DATES","rUNEMP")]
my_title <- "Unemployment modeling"
unemp_plot <- ggplot(data = rUNEMP_df, aes(DATES, rUNEMP)) +
  geom_point() +
  geom_line(data = rUNEMP_pred_df, aes(DATES, rUNEMP_PRED)) +
  geom_ribbon(data = rUNEMP_pred_df,aes(ymin = rUNEMP_DOWN,ymax = rUNEMP_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### CONSUMPTION
rCONS_pred_df <-
  total_df[past_twenty_index,c("DATES","rCONS","rCONS_PRED","rCONS_DOWN","rCONS_UP")]
rCONS_df <- total_df[past_twenty_index,c("DATES","rCONS")]
my_title <- "Consumption modeling"
cons_plot <- ggplot(data = rCONS_df, aes(DATES, rCONS)) +
  geom_point() +
  geom_line(data = rCONS_pred_df, aes(DATES, rCONS_PRED)) +
  geom_ribbon(data = rCONS_pred_df,aes(ymin = rCONS_DOWN,ymax = rCONS_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### CONSUMER PRICE INDEX
rCPI_pred_df <-
  total_df[past_twenty_index,c("DATES","rCPI","rCPI_PRED","rCPI_DOWN","rCPI_UP")]
rCPI_df <- total_df[past_twenty_index,c("DATES","rCPI")]
my_title <- "Consumer price index modeling"
cpi_plot <- ggplot(data = rCPI_df, aes(DATES, rCPI)) +
  geom_point() +
  geom_line(data = rCPI_pred_df, aes(DATES, rCPI_PRED)) +
  geom_ribbon(data = rCPI_pred_df,aes(ymin = rCPI_DOWN,ymax = rCPI_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))


##### GDP Deflator
rDEF_pred_df <-
  total_df[past_twenty_index,c("DATES","rDEF","rDEF_PRED","rDEF_DOWN","rDEF_UP")]
rDEF_df <- total_df[past_twenty_index,c("DATES","rDEF")]
my_title <- "GDP deflator modeling"
def_plot <- ggplot(data = rDEF_df, aes(DATES, rDEF)) +
  geom_point() +
  geom_line(data = rDEF_pred_df, aes(DATES, rDEF_PRED)) +
  geom_ribbon(data = rDEF_pred_df,aes(ymin = rDEF_DOWN,ymax = rDEF_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### GCE
rGCE_pred_df <-
  total_df[past_twenty_index,c("DATES","rGCE","rGCE_PRED","rGCE_DOWN","rGCE_UP")]
rGCE_df <- total_df[past_twenty_index,c("DATES","rGCE")]
my_title <- "Government consumption expenditure"
gce_plot <- ggplot(data = rGCE_df, aes(DATES, rGCE)) +
  geom_point() +
  geom_line(data = rGCE_pred_df, aes(DATES, rGCE_PRED)) +
  geom_ribbon(data = rGCE_pred_df,aes(ymin = rGCE_DOWN,ymax = rGCE_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### GDP
rGDP_pred_df <-
  total_df[past_twenty_index,c("DATES","rGDP","rGDP_PRED","rGDP_DOWN","rGDP_UP")]
rGDP_df <- total_df[past_twenty_index,c("DATES","rGDP")]
my_title <- "Gross domestic product"
gdp_plot <- ggplot(data = rGDP_df, aes(DATES, rGDP)) +
  geom_point() +
  geom_line(data = rGDP_pred_df, aes(DATES, rGDP_PRED)) +
  geom_ribbon(data = rGDP_pred_df,aes(ymin = rGDP_DOWN,ymax = rGDP_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))


##### HOOURS
rHOURS_pred_df <-
  total_df[past_twenty_index,c("DATES","rHOURS","rHOURS_PRED","rHOURS_DOWN","rHOURS_UP")]
rHOURS_df <- total_df[past_twenty_index,c("DATES","rHOURS")]
my_title <- "Hour worked"
hours_plot <- ggplot(data = rHOURS_df, aes(DATES, rHOURS)) +
  geom_point() +
  geom_line(data = rHOURS_pred_df, aes(DATES, rHOURS_PRED)) +
  geom_ribbon(data = rHOURS_pred_df,aes(ymin = rHOURS_DOWN,ymax = rHOURS_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### INVESTMENT
rINV_pred_df <-
  total_df[past_twenty_index,c("DATES","rINV","rINV_PRED","rINV_DOWN","rINV_UP")]
rINV_df <- total_df[past_twenty_index,c("DATES","rINV")]
my_title <- "Investment"
inv_plot <- ggplot(data = rINV_df, aes(DATES, rINV)) +
  geom_point() +
  geom_line(data = rINV_pred_df, aes(DATES, rINV_PRED)) +
  geom_ribbon(data = rINV_pred_df,aes(ymin = rINV_DOWN,ymax = rINV_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### WAGES
rWAGES_pred_df <-
  total_df[past_twenty_index,c("DATES","rWAGES","rWAGES_PRED","rWAGES_DOWN","rWAGES_UP")]
rWAGES_df <- total_df[past_twenty_index,c("DATES","rWAGES")]
my_title <- "Wages"
wage_plot <- ggplot(data = rWAGES_df, aes(DATES, rWAGES)) +
  geom_point() +
  geom_line(data = rWAGES_pred_df, aes(DATES, rWAGES_PRED)) +
  geom_ribbon(data = rWAGES_pred_df,aes(ymin = rWAGES_DOWN,ymax = rWAGES_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### FED
rFED_pred_df <-
  total_df[past_twenty_index,c("DATES","rFED","rFED_PRED","rFED_DOWN","rFED_UP")]
rFED_df <- total_df[past_twenty_index,c("DATES","rFED")]
my_title <- "FED short rates"
fed_plot <- ggplot(data = rFED_df, aes(DATES, rFED)) +
  geom_point() +
  geom_line(data = rFED_pred_df, aes(DATES, rFED_PRED)) +
  geom_ribbon(data = rFED_pred_df,aes(ymin = rFED_DOWN,ymax = rFED_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### 3 Month treasury rates
rTB3_pred_df <-
  total_df[past_twenty_index,c("DATES","rTB3","rTB3_PRED","rTB3_DOWN","rTB3_UP")]
rTB3_df <- total_df[past_twenty_index,c("DATES","rTB3")]
my_title <- "3 month treasury rates"
t3m_plot <- ggplot(data = rTB3_df, aes(DATES, rTB3)) +
  geom_point() +
  geom_line(data = rTB3_pred_df, aes(DATES, rTB3_PRED)) +
  geom_ribbon(data = rTB3_pred_df,aes(ymin = rTB3_DOWN,ymax = rTB3_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))


##### 10 years treasury rates
rG10_pred_df <-
  total_df[past_twenty_index,c("DATES","rG10","rG10_PRED","rG10_DOWN","rG10_UP")]
rG10_df <- total_df[past_twenty_index,c("DATES","rG10")]
my_title <- "10 years treasury rates"
g10_plot <- ggplot(data = rG10_df, aes(DATES, rG10)) +
  geom_point() +
  geom_line(data = rG10_pred_df, aes(DATES, rG10_PRED)) +
  geom_ribbon(data = rG10_pred_df,aes(ymin = rG10_DOWN,ymax = rG10_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### Money supply 1
rM1_pred_df <-
  total_df[past_twenty_index,c("DATES","rM1","rM1_PRED","rM1_DOWN","rM1_UP")]
rM1_df <- total_df[past_twenty_index,c("DATES","rM1")]
my_title <- "Money supply 1"
m1_plot <- ggplot(data = rM1_df, aes(DATES, rM1)) +
  geom_point() +
  geom_line(data = rM1_pred_df, aes(DATES, rM1_PRED)) +
  geom_ribbon(data = rM1_pred_df,aes(ymin = rM1_DOWN,ymax = rM1_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

##### Money supply 2
rM2_pred_df <-
  total_df[past_twenty_index,c("DATES","rM2","rM2_PRED","rM2_DOWN","rM2_UP")]
rM2_df <- total_df[past_twenty_index,c("DATES","rM2")]
my_title <- "Money supply 2"
m2_plot <- ggplot(data = rM2_df, aes(DATES, rM2)) +
  geom_point() +
  geom_line(data = rM2_pred_df, aes(DATES, rM2_PRED)) +
  geom_ribbon(data = rM2_pred_df,aes(ymin = rM2_DOWN,ymax = rM2_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))
##### SP500 plot 
rSP500_pred_df <-
  total_df[past_twenty_index,c("DATES","rSP500","rSP500_PRED","rSP500_DOWN","rSP500_UP")]
rSP500_df <- total_df[past_twenty_index,c("DATES","rSP500")]

my_title <- "S&P 500"
sp500_plot <- ggplot(data = rSP500_df, aes(DATES, rSP500)) +
  geom_point() +
  geom_line(data = rSP500_pred_df, aes(DATES, rSP500_PRED)) +
  geom_ribbon(data = rSP500_pred_df,aes(ymin = rSP500_DOWN,ymax = rSP500_UP),alpha =
                0.5) +
  scale_x_date() +
  ggtitle(my_title) + xlab("") + ylab("") +
  theme(title = element_text(size = 12, face = 'bold')) +
  theme(legend.position = c(0.9,0.9), legend.box = "vertical") +
  theme(legend.background = element_rect(fill = "gray90")) +
  theme(legend.key.size = unit(0.3, "cm"))

### Getting bigger margins to plot
par(mar = rep(2, 4))
multiplot(
  cons_plot,cpi_plot,def_plot,gce_plot,gdp_plot,hours_plot,inv_plot,wage_plot,fed_plot,t3m_plot,g10_plot,m1_plot,unemp_plot, m2_plot, sp500_plot, cols =
    3
)