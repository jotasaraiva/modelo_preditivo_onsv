library(tidyverse)
library(arrow)

url <- "https://github.com/ONSV/prfdata/releases/download/v0.2.0/prf_sinistros.zip"

temp_file <- tempfile()
temp_dir <- tempdir()

download.file(url, temp_file, quiet = T)
unzip(temp_file, exdir = temp_dir)

sinistros_prf_mensal <- open_dataset(file.path(temp_dir,"prf_sinistros")) |> 
  mutate(
    mes = month(data_inversa),
    acidentes_fatais = if_else(
      classificacao_acidente == "Com Vítimas Fatais",
      1, 0, missing = 0
    )
  ) |> 
  summarise(
    .by = c(mes, ano, uf),
    acidentes = n(),
    acidentes_fatais = sum(acidentes_fatais),
    feridos = sum(feridos),
    mortes = sum(mortos)
  ) |> 
  arrange(mes, ano) |> 
  collect()

unlink(temp_file)

save(sinistros_prf_mensal, file = "data/sinistros_prf_mensal.rda")