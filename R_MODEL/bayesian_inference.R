library("dplyr")
library("ggplot2")

#' Generates a "Triangle" Prior Probability Distribution
#'
#' @param vals Sample space of all possible parameter values.
#' @return 2 column data.frame containing the parameter and its corresponding
#'   prior probability.
get_prior_distr <- function(vals) {
  vals.pmin <- pmin(vals, 1 - vals)
  
  # Normalize the prior so that they sum to 1.
  dplyr::data_frame(theta = vals,
                    prior = vals.pmin / sum(vals.pmin))
}

# Define the Space of all theta values
theta.vals <- seq(0, 1, 0.1)

theta.prior.distr.df <- get_prior_distr(theta.vals)

#' Plots the Prior Probability Distribution
#'
#' @param prior.distr.df Prior probability distribution data.frame from 
#'   get_prior_distr().
#' @param plot.x.labels Plot the parameter values on the x-axes that are taken
#'  from the input data.
plot_prior_distr <- function(prior.distr.df, plot.x.labels = TRUE) {
  
  theta.prior.p <- 
    prior.distr.df %>%
    ggplot(aes(x = theta, y = prior)) +
    geom_point() +
    geom_segment(aes(x = theta, xend = theta, y = prior, yend = 0)) +
    xlab(expression(theta)) +
    ylab(expression(paste("P(", theta, ")"))) +
    ggtitle("Prior Distribution") 
  
  if (plot.x.labels) {
    theta.vals <- prior.distr.df[["theta"]]
    
    theta.prior.p <- 
      theta.prior.p + 
      scale_x_continuous(breaks = c(theta.vals),
                         labels = theta.vals)
  }
  
  theta.prior.p
}

plot_prior_distr(theta.prior.distr.df)