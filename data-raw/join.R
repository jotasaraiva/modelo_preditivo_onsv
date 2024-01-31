library(tidyverse)
library(here)

enderecos_data <- c(
  here("data","frota_veiculos.rda"),
  here("data","obitos_transito.rda"),
  here("data","pib.rda"),
  here("data","populacao.rda"),
  here("data","quilometragem.rda"),
  here("data","sinistros_prf.rda"),
  here("data","tabela_condutores.rda")
)

for (k in enderecos_data) { load(k) }

frota_veiculos <- frota_veiculos |> 
  rename(
    veiculos_total = total,
    ano = anos
  )

df_list <- list(
  frota_veiculos,
  obitos_transito,
  pib,
  populacao,
  sinistros_prf,
  tabela_condutores,
  quilometragem
)

df_total <- df_list |> 
  reduce(full_join, by = "ano") |> 
  relocate(ano) |> 
  arrange(ano)

mortes_hab <- df_total |> 
  select(ano, mortes, populacao) |> 
  drop_na() |> 
  mutate(mortos_por_pop = mortes / populacao * 100000) |> 
  select(ano, mortos_por_pop)

df_total <- left_join(df_total, mortes_hab, by = "ano")

save(df_total, file = here("data","tabela_total.rda"))