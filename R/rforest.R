library(tidyverse)
library(fleetbr)
library(roadtrafficdeaths)
library(here)
library(arrow)
library(tidymodels)

load(here("data/pib_mensal.rda"))
temp <- tempfile()
download.file("https://github.com/ONSV/prfdata/releases/download/v0.2.0/prf_sinistros.zip", temp)
unzip(temp, exdir = tempdir())
unlink(temp)
prf_sinistros <- open_dataset(paste(sep = "/", file.path(tempdir()), "prf_sinistros"))

metricas <- metric_set(rmse, mae, rsq)

df_frota_2023 <- fleetbr |> 
  pivot_wider(names_from = modal, values_from = frota) |> 
  mutate(
    data = ym(paste0(ano,"-",mes)),
    automovel = AUTOMOVEL + CAMINHONETE + CAMIONETA + UTILITARIO,
    motocicleta = MOTOCICLETA + CICLOMOTOR + MOTONETA
  ) |> 
  rename(total = TOTAL) |> 
  summarise(
    .by = data,
    veiculos = sum(total),
    automovel = sum(automovel),
    motocicleta = sum(motocicleta)
  )

df_mortes_2023 <- rtdeaths |> 
  mutate(mes = month(data_ocorrencia),
         ano = year(data_ocorrencia),
         data = ym(paste0(ano, "-", mes))) |> 
  count(data, name = "mortes") |> 
  drop_na()

df_pib_2023 <- pib_mensal |> 
  mutate(data = ym(paste0(ano, "-", mes))) |> 
  group_by(data) |> 
  summarise(pib)

df_prf_2023 <- prf_sinistros |> 
  collect() |> 
  mutate(
    acidentes_fatais = if_else(
      classificacao_acidente == "Com Vítimas Fatais", 1, 0, missing = 0
    ),
    mes = month(data_inversa),
    data = ym(paste0(ano, "-", mes))
  ) |> 
  summarise(
    .by = data,
    acidentes = n(),
    acidentes_fatais = sum(acidentes_fatais),
    feridos = sum(feridos),
    mortes_prf = sum(mortos)
  ) |> 
  arrange(data)

dados_mensais_2023 <- 
  list(df_frota_2023, df_mortes_2023, df_pib_2023, df_prf_2023) |> 
  reduce(full_join, by = "data") |> 
  arrange(data)

split_2023 <- initial_split(drop_na(dados_mensais_2023), prop = 0.8)

train_2023 <- training(split_2023)
test_2023 <- testing(split_2023)

rec_mensal_2023 <-
  recipe(train_2023, mortes ~ .) |> 
  remove_role(c(mortes_prf, data), old_role = "predictor") |> 
  step_normalize(all_numeric_predictors())

rf <- 
  rand_forest(
    mode = "regression",
    mtry = 5,
    trees = 5000
  ) |> 
  set_engine("ranger")

rf_wflow <- 
  workflow() |> 
  add_model(rf) |> 
  add_recipe(rec_mensal_2023) |>
  fit(train_2023)

rf_pred <- bind_cols(
  predict(rf_wflow, drop_na(dados_mensais_2023, veiculos)),
  drop_na(dados_mensais_2023, veiculos)
)

metricas_rf <- bind_cols(
  predict(rf_wflow, test_2023),
  test_2023
) |> 
  metricas(truth = mortes, estimate = .pred)