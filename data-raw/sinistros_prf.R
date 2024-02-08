library(arrow)
library(tidyverse)

url <- "https://github.com/ONSV/prfdata/releases/download/v0.2.0/prf_sinistros.zip"

temp_file <- tempfile()
temp_dir <- tempdir()

download.file(url, temp_file, quiet = T)
unzip(temp_file, exdir = temp_dir)

sinistros_prf <- open_dataset(file.path(temp_dir, "prf_sinistros")) |> 
  mutate(
    acidentes_fatais = if_else(
      classificacao_acidente == "Com Vítimas Fatais",
      1, 0, missing = 0
    )
  ) |> 
  summarise(
    .by = ano,
    qnt_acidentes = n(),
    qnt_acidentes_fatais = sum(acidentes_fatais),
    qnt_feridos = sum(feridos),
    qnt_mortos = sum(mortos)
  ) |> 
  arrange(ano) |> 
  filter(ano <= 2021) |> 
  collect()

unlink(temp_file)

save(sinistros_prf, file = "data/sinistros_prf.rda")