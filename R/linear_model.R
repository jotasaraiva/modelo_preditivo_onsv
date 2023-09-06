lm_model <- function(df) {
  modelo_lm <- linear_reg() |> set_engine("lm")
  
  rec <- df |> 
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
    fit(df)
  
  return(linear_wflow)
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