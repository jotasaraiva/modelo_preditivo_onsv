library(here)
library(tidyverse)

load(here("data","obitos_transito_mensal.rda"))
load(here("data","frota_mensal.rda"))
load(here("data","pib_mensal.rda"))
load(here("data","sinistros_prf_mensal.rda"))

brazil_states_acronym <- function(df) {
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
  
  for(i in 1:length(df$uf)) {
    for(j in 1:length(brazil_states_df$State)) {
      if(df$uf[i] == brazil_states_df$State[j] & !is.na(df$uf[i])) {
        df$uf[i] <- brazil_states_df$Acronym[j]
      }
    }
  }
  
  return(df)
}

df_frota <- frota_mensal |> 
  pivot_wider(names_from = modal, values_from = frota) |> 
  mutate(automovel = AUTOMOVEL + CAMINHONETE + CAMIONETA + UTILITARIO,
         motocicleta = MOTOCICLETA + CICLOMOTOR + MOTONETA,
         veiculos = TOTAL,
         data = ym(paste0(ano,'-',mes))) |> 
  select(data, uf, automovel, motocicleta, veiculos)

df_mortes <- obitos_transito_mensal |> 
  brazil_states_acronym() |> 
  mutate(data = ym(paste0(ano,'-',mes))) |> 
  summarise(
    .by = c(data, uf),
    mortes = sum(mortes)
  )

df_prf <- sinistros_prf_mensal |> 
  mutate(data = ym(paste0(ano,'-',mes))) |> 
  select(-c(mes,ano)) |> 
  relocate(data) |> 
  filter(!(uf == "(null)")) |> 
  rename(mortes_prf = mortes)

dados_mensais_uf <- reduce(
  list(df_frota, df_prf, df_mortes),
  inner_join,
  by = c("data","uf")
)

save(dados_mensais_uf, file = "data/tabela_total_mes_uf.rda")