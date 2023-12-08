library(here)
library(tidyverse)
library(tidymodels)

load(here("data","obitos_transito_mensal.rda"))
load(here("data","frota_mensal.rda"))
load(here("data","pib_mensal.rda"))
load(here("data","sinistros_prf_mensal.rda"))

df_frota <- frota_mensal |> 
  pivot_wider(names_from = modal, values_from = frota) |> 
  mutate(
    data = ym(paste0(ano,"-",mes)),
    automovel = AUTOMOVEL, CAMINHONETE, CAMIONETA, UTILITARIO,
    motocicleta = MOTOCICLETA, CICLOMOTOR, MOTONETA
  ) |> 
  rename(total = TOTAL) |> 
  summarise(
    .by = data,
    total = sum(total),
    automovel = sum(automovel),
    motocicleta = sum(motocicleta)
  )

df_mortes <- obitos_transito_mensal |> 
  select(-uf) |> 
  drop_na() |> 
  mutate(data = ym(paste0(ano,"-",mes))) |> 
  summarise(
    .by = data,
    mortes = sum(mortes)
  )

df_pib <- pib_mensal |> 
  mutate(data = ym(paste0(ano,"-",mes))) |> 
  select(data, pib)

df_prf <- sinistros_prf_mensal |> 
  mutate(data = ym(paste0(ano,"-",mes))) |> 
  summarise(
    .by = data,
    acidentes = sum(acidentes),
    acidentes_fatais = sum(acidentes_fatais),
    feridos = sum(feridos),
    mortes_prf = sum(mortes)
  )

dados_mensais <- reduce(
  list(df_frota, df_mortes, df_pib, df_prf),
  inner_join,
  by = "data"
) |> 
  rename(veiculos = total)

save(dados_mensais, file = here("data","tabela_total_mensal.rda"))