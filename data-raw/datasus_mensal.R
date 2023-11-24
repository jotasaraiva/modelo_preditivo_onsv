obitos_transito_mensal <- rtdeaths |> 
  mutate(mes_ocorrencia = month(data_ocorrencia)) |>
  count(mes_ocorrencia, ano_ocorrencia, nome_uf_ocor) |> 
  arrange(ano_ocorrencia) |> 
  rename(
    mortes = n,
    mes = mes_ocorrencia,
    ano = ano_ocorrencia,
    uf = nome_uf_ocor
  )

save(obitos_transito_mensal, file = "data/obitos_transito_mensal.rda")