library(here)
library(tidyverse)

load(here("data","obitos_transito_mensal.rda"))
load(here("data","frota_mensal.rda"))
load(here("data","pib_mensal.rda"))
load(here("data","sinistros_prf_mensal.rda"))

brazil_states_df <- data.frame(
  State = c(
    "Acre", "Alagoas", "Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal",
    "Espírito Santo", "Goiás", "Maranhão", "Mato Grosso", "Mato Grosso do Sul",
    "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí",
    "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima",
    "Santa Catarina", "São Paulo", "Sergipe", "Tocantins"
  ),
  Acronym = c(
    "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG",
    "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"
  )
)

df_frota <- frota_mensal |> 
  pivot_wider(names_from = modal, values_from = frota) |> 
  mutate(automovel = AUTOMOVEL + CAMINHONETE + CAMIONETA + UTILITARIO,
         motocicleta = MOTOCICLETA + CICLOMOTOR + MOTONETA,
         total = TOTAL,
         data = ym(paste0(ano,'-',mes))) |> 
  select(data, uf, automovel, motocicleta, total)