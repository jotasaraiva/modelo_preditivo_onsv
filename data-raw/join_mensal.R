library(here)
library(tidyverse)
library(fleetbr)
library(roadtrafficdeaths)

load(here("data","pib_mensal.rda"))
load(here("data","sinistros_prf_mensal.rda"))

df_mortes <- rtdeaths |> 
  mutate(data = ym(paste0(year(data_ocorrencia),'-',month(data_ocorrencia)))) |> 
  summarise(.by = data, mortes = n()) |> 
  drop_na() |> 
  arrange(data)

df_frota <- fleetbr |> 
  pivot_wider(names_from = modal, values_from = frota) |> 
  mutate(
    data = ym(paste0(ano,'-',mes)),
    automovel = AUTOMOVEL + CAMINHONETE + CAMIONETA + UTILITARIO,
    motocicleta = MOTOCICLETA + CICLOMOTOR + MOTONETA
  ) |> 
  rename(total = TOTAL) |> 
  summarise(
    .by = data,
    total = sum(total),
    automovel = sum(automovel),
    motocicleta = sum(motocicleta)
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