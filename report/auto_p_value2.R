library(tidyverse)
library(tidymodels)
library(here)
tidymodels_prefer()
options(scipen = 999)

load(here("data","tabela_total.rda"))

df_total <- df_total |> select(-mortos_por_pop)

modelo <- linear_reg() |> set_engine("lm")

metricas <- metric_set(rmse, mae, rsq)

for (i in colnames(df_total)[-5]){
  
  rec <- df_total |>
    recipe(vars = c("mortes", i), roles = c("outcome", "predictor")) |>
    step_naomit(all_numeric()) |>
    step_normalize(all_numeric_predictors())

  wflow_fit <- workflow() |>
    add_model(modelo) |>
    add_recipe(rec) |>
    fit(df_total)

  if (i == "ano") {
    pvalores <- wflow_fit |> tidy()
  } else {
    pvalores <- rbind(pvalores, wflow_fit |> tidy())
  }
  
  predicao <- wflow_fit |> 
    predict(df_total) |>
    cbind(df_total)
    
  medidas <- predicao |> 
    metricas(.pred, mortes) |> 
    mutate(variavel = i)
  
  if (i == "ano") {
    erros <- medidas
  } else {
    erros <- rbind(erros, medidas)
  }
  
}

erros_pivot <- erros |> 
  select(!.estimator) |> 
  pivot_wider(names_from = variavel, values_from = .estimate)

pvalores <- pvalores |> 
  filter(term != "(Intercept)") |> 
  arrange(p.value)

save(erros_pivot, file = here("report","metricas_de_erro.rda"))

save(pvalores, file = here("report","pvalores.rda"))
