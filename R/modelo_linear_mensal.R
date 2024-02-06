library(recipes)
library(parsnip)
library(workflows)

linear_mensal_recipe <- function(data) {
  rec <- data |> 
    recipe(mortes ~ .) |> 
    remove_role(c(mortes_prf, data), old_role = "predictor") |> 
    step_normalize(all_numeric_predictors())
  
  return(rec)
}

linear_mensal_wflow <- function(recipe, data) {
  linear_specs <-
    linear_reg() |> 
    set_engine("lm")
  
  linear_wflow <-
    workflow() |> 
    add_recipe(recipe) |> 
    add_model(linear_specs) |> 
    fit(data)
  
  return(linear_wflow)
}