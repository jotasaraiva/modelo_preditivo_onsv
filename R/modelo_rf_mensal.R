library(parsnip)
library(workflows)
library(recipes)

rf_mensal_recipe <- function(data) {
  rec <- data |> 
    recipe(mortes ~ .) |> 
    remove_role(c(mortes_prf, data), old_role = "predictor") |> 
    step_normalize(all_numeric_predictors())
  
  return(rec)
}

rf_mensal_wflow <- function(recipe, data) {
  rf_specs <-
    rand_forest(
      mode = "regression",
      mtry = 5,
      trees = 5000
    ) |> 
    set_engine("ranger")
  
  rf_wflow <-
    workflow() |> 
    add_recipe(recipe) |> 
    add_model(rf_specs) |> 
    fit(data)
  
  return(rf_wflow)
}
