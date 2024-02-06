library(tidyverse)
library(arrow)

data <- read_parquet("https://github.com/ONSV/prfdata/releases/download/v0.1.0/prf_sinistros.parquet")

sinistros_prf_mensal <- data |> 
  mutate(acid_fatal = if_else(classificacao_acidente == "Com Vítimas Fatais",
                              1, 0, missing  = 0),
         mes = month(data_inversa)) |> 
  filter(!(ano == 2023 & mes > 10)) |> 
  summarise(
    .by = c(mes, ano, uf),
    acidentes = n(),
    acidentes_fatais = sum(acid_fatal),
    feridos = sum(feridos),
    mortes = sum(mortos)
  ) |> 
  arrange(ano, mes)

save(sinistros_prf_mensal, file = "data/sinistros_prf_mensal.rda")