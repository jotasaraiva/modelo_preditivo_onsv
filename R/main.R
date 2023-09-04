library(tidyverse)
library(tidymodels)
library(onsvplot)
tidymodels_prefer()
options(scipen = 999)

load(here("data", "tabela_total.rda"))

modelo_lm <- linear_reg() |> set_engine("lm")

rec <- df_total |> 
  recipe(
    mortes ~
      qnt_acidentes_fatais + 
      qnt_acidentes + 
      qnt_feridos +
      condutores +
      populacao +
      veiculos_total +
      pib
  ) |> 
  step_naomit(all_numeric()) |> 
  step_normalize(all_numeric_predictors())

linear_wflow <- workflow() |> 
  add_recipe(rec) |> 
  add_model(modelo_lm) |> 
  fit(df_total)

df_pred <- linear_wflow |> 
  predict(df_total) |> 
  cbind(df_total)

metricas <- metric_set(rmse, mae, rsq)

erros <- metricas(df_pred, truth = mortes, estimate = .pred)