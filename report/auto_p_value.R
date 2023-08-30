library(tidyverse)
library(tidymodels)
library(here)
library(knitr)
tidymodels_prefer()
options(scipen = 999)

load(here("data","tabela_total.rda"))

i <- "mortos_por_pop"

for (i in df_total |> colnames()) {
  rc_temp <- df_total |> 
    recipe(mortes ~ .) |>
    step_naomit(all_numeric()) |> 
    step_normalize(all_numeric_predictors()) |>
    step_select(mortes, i)
  
  modelo <- linear_reg() |> set_engine("lm")
  
  wflow_fit <- workflow() |> 
    add_recipe()
}



