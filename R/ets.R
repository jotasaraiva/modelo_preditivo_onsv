library(tidyverse)
library(roadtrafficdeaths)
library(forecast)
library(tidymodels)

metricas <- metric_set(rmse, mae, rsq)

df_mortes <- rtdeaths |> 
  arrange(data_ocorrencia) |> 
  mutate(data = ym(paste0(ano_ocorrencia, '-', month(data_ocorrencia))),
         .before = 1) |> 
  summarise(.by = data, mortes = n()) |> 
  drop_na()

ts <- ts(df_mortes$mortes, start = c(1996, 1), end = c(2022, 12), frequency = 12)

ets <- HoltWinters(ts)

ets_pred <- cbind(fit = ets$fitted[, "xhat"], 
                  forecast = forecast(ets, h = 12)$mean, 
                  mortes = ets$x,
                  .pred_lower = forecast(ets, h = 12)$lower,
                  .pred_upper = forecast(ets, h = 12)$upper)
ets_pred <- 
  data.frame(ets_pred, data = zoo::as.Date(time(ets_pred))) |> 
  mutate(.pred = coalesce(forecast, fit), .before = 1) |> 
  select(-c(fit, forecast))

metricas_ets <- metricas(ets_pred, truth = mortes, estimate = .pred)