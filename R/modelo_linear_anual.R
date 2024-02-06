library(dplyr)
library(tidyr)
library(parsnip)
library(workflows)

linear_anual_recipe <- function(data) {
  rec <- data |> 
    recipe(
      mortes ~ 
        veiculos_total + 
        qnt_acidentes_fatais +
        condutores + 
        qnt_acidentes
    ) |> 
    step_normalize(all_numeric_predictors())
  
  return(rec)
}

linear_anual_wflow <- function(recipe, data) {
  linear_specs <- 
    linear_reg() |> 
    set_engine("lm")
  
  linear_wflow <-
    workflow() |> 
    add_model(linear_specs) |> 
    add_recipe(recipe) |> 
    fit(data)
  
  return(linear_wflow)  
}