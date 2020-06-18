library(data.table)
library(tidytable)
library(purrr)

scale_parameters <- function(train_data){
  train_means <- train_data %>% 
    map_dbl(function(x) mean(x)) %>% 
    unname()
  
  train_vars <- train_data %>% 
    map_dbl(function(x) stats::var(x)) %>% 
    unname()
  
  return(data.frame(train_mean = train_means, train_vars = train_vars))
}

trained_scaler <-function(data, sp){ 
  centered_predictors <- sweep(data, 2, sp$train_mean)
  scaled_predictors <- sweep(centered_predictors, 2, sp$train_vars, FUN = "/")
}