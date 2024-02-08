load("data/frota_veiculos.rda")
load("data/obitos_transito.rda")
load("data/pib.rda")
load("data/populacao.rda")
load("data/sinistros_prf.rda")
load("data/tabela_condutores.rda")
load("data/quilometragem.rda")

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