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

sarima <- auto.arima(
  ts,
  stationary = F,
  seasonal = T
)

sarima_pred <- cbind(fit = sarima$fitted, 
                     forecast = forecast(sarima, h = 12)$mean, 
                     mortes = sarima$x,
                     .pred_lower = forecast(sarima, h = 12)$lower,
                     .pred_upper = forecast(sarima, h = 12)$upper)
sarima_pred <- 
  data.frame(sarima_pred, data = zoo::as.Date(time(sarima_pred))) |> 
  mutate(.pred = coalesce(forecast, fit), .before = 1) |> 
  select(-c(fit, forecast))

metricas_sarima <- metricas(sarima_pred, truth = mortes, estimate = .pred)