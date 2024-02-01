library(tidyverse)
library(roadtrafficdeaths)

obitos_transito <- rtdeaths |> 
  count(ano_ocorrencia, name = "mortes") |> 
  rename(ano = ano_ocorrencia) |> 
  drop_na() |> 
  filter(ano < 2022)

save(obitos_transito, file = "data/obitos_transito.rda")