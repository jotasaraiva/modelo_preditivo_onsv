enderecos_data <- paste(
  here(
    "data",
    list.files(here("data"))
  )
)

for (k in enderecos_data) {load(k)}

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