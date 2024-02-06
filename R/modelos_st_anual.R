library(dplyr)
library(lubridate)
library(tidyr)
library(forecast)

criar_serie_temporal <- function(data) {
  df <- data |> 
    mutate(data = ym(paste0(ano, '-', mes))) |> 
    group_by(data) |> 
    summarise(mortes = sum(mortes)) |> 
    drop_na() |> 
    arrange(data)
  
  ts <- ts(
    df$mortes, 
    start = c(year(first(df$data)), month(first(df$data))),
    end = c(year(last(df$data)), month(last(df$data))),
    frequency = 12
  )
  
  return(ts)
}

sarima_mensal <- function(ts) {
  model <- auto.arima(
    ts,
    stationary = FALSE,
    seasonal = TRUE
  )
  
  return(model)
}

ets_mensal <- function(ts) {
  model <- HoltWinters(ts)
  
  return(model)
}