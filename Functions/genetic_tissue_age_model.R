# Create function that outputs a trained model for a gdata value

age_tissue_guesser <- function(gdata,
                               seed = 123,
                               max_sample = 300,
                               v=10,
                               metric = "accuracy"){
  library(data.table)
  library(tidytable)
  library(hash)
  library(glmnet)
  library(tidymodels)
  
  # Create hashmap for ages and set the values equal to y
  h <- hash()
  h[['20-29']] <- 0
  h[['30-39']] <- 1
  h[['40-49']] <- 2
  h[['50-59']] <- 3
  h[['60-69']] <- 4
  h[['70-79']] <- 5
  y <- unname(values(h, keys = gdata$AGE))
  
  # Grab the genes from our gdata object
  x <- gdata %>% 
    select.(-c(SAMPID, SMTS, SEX, DTHHRDY, AGE))
  
  # Sample our data so that there is max_samples samples of each class
  set.seed(123)
  boot_0 <- sample(which(y==0), max_sample, replace = TRUE)
  boot_1 <- sample(which(y==1), max_sample, replace = TRUE)
  boot_2 <- sample(which(y==2), max_sample, replace = TRUE)
  boot_3 <- sample(which(y==3), max_sample, replace = TRUE)
  boot_4 <- sample(which(y==4), max_sample, replace = TRUE)
  boot_5 <- sample(which(y==5), max_sample, replace = TRUE)
  new_id <- c(boot_0, boot_1, boot_2, boot_3, boot_4, boot_5)
  
  # Recreate our x,y
  x <- as.matrix(x[new_id,])
  y <- y[new_id]
  
  # Do a cross_validation for lasso
  lambda_finder <- cv.glmnet(x,y, alpha = 1)
  
  # Do lasso with the lambda.min
  lasso_model <- glmnet(x, y, alpha = 1, lambda = lambda_finder$lambda.min)
  
  # Create vectors for selected features
  fs_ind <- lasso_model$beta@i
  
  # Create new x based on selected features
  x <- x[,fs_ind]
  
  # Time to initialize XGboost model
  model <- boost_tree(mode = "classification",
                 mtry = 30,
                 min_n = tune(),
                 trees = 500,
                 tree_depth = tune()) %>% 
    set_engine("xgboost")
  
  # Create a data frame with target|data format
  t_df<- data.frame(x,y=as.factor(y))
  
  # Create grid, folds, and do cross validation to tune model
  x_grid <- grid_regular(min_n(),
                         tree_depth())
  
  x_folds <- vfold_cv(t_df, v=v)
  x_res <- tune_grid(model, preprocessor = y~., resamples = x_folds, grid = x_grid)
  
  # Update model with best parameters
  model <- model %>% finalize_model(select_best(x_res, metric = metric))
  
  #Fit your model
  fitted_model <- model %>% fit(y~., data = t_df)
  
  # Return named list of needed values for future predictions
  return(list(model = fitted_model, selected_features = fs_ind))
  
}

predict_age <- function(tissue_model, new_data){
  h <- hash()
  h[['20-29']] <- 0
  h[['30-39']] <- 1
  h[['40-49']] <- 2
  h[['50-59']] <- 3
  h[['60-69']] <- 4
  h[['70-79']] <- 5
  y <- unname(values(h, keys = new_data$AGE))
  x <- new_data %>% 
    select.(-c(SAMPID, SMTS, SEX, DTHHRDY, AGE)) %>% 
    as.matrix()
  pred_values <- tissue_model$model %>% 
    predict(new_data = data.frame(x[,tissue_model$selected_features]))
  print(paste0("The classification accuracy is ", mean(pred_values$.pred_class==y)))
  return(pred_values)
}