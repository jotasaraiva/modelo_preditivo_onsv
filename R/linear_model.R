lm_model <- function(df) {
  
  modelo_lm <- linear_reg() |> set_engine("lm")
  
  df_preproc <- df |> 
    select(
      ano,
      mortes,
      qnt_acidentes_fatais,
      qnt_acidentes,
      condutores,
      veiculos_total
    ) |> drop_na()
  
  rec_preproc <- df_preproc |> 
    recipe(
      mortes ~ qnt_acidentes + qnt_acidentes_fatais + condutores + veiculos_total
    ) |> 
    step_normalize(all_numeric_predictors())
  
  lm_wflow <- workflow() |> 
    add_model(modelo_lm) |> 
    add_recipe(rec_preproc) |> 
    fit(df_preproc)
  
  return(lm_wflow)
}

lm_extract <- function(model, input) {
  metricas <- metric_set(rmse, mae, rsq)
  
  pred <- predict(model, input) |> 
    cbind(df_total) |> 
    rename(mortes.pred = .pred) |> 
    as.data.frame()
  
  erros <- metricas(pred, truth = mortes, estimate = mortes.pred) |> 
    as.data.frame()
  
  specs <- model |> 
    tidy() |> 
    as.data.frame()
  
  res <- list("pred" = pred, "metric" = erros, "coef" = specs)
  
  return(res)
}

lm_complete <- function(df) {
  model <- lm_model(df)
  
  extrac <- lm_extract(model, df)
  
  res <- list(
    "model" = model,
    "pred" = extrac$pred,
    "metric" = extrac$metric,
    "coef" = extrac$coef
  )
  
  return(res)
} 