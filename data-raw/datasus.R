df_datasus <- fetch_datasus(
  year_start = 1996,
  year_end = 2021,
  information_system = "SIM-DOEXT",
  vars = c("DTOBITO","CAUSABAS")
)

st_datasus <- df_datasus |> 
  filter(
    str_detect(CAUSABAS, paste(paste0("V", seq(0, 8, 1)), collapse = "|"))
  ) |> 
  mutate(
    datas = as.character(DTOBITO),
    ano = as.numeric(str_sub(datas, -4, -1))
  )

save(st_datasus, file = "data-raw/datasus.rda")

obitos_ano <- st_datasus |> 
  count(ano, name = "mortes") |> 
  as_tibble()

save(obitos_ano, file = "data/obitos_ano.rda")