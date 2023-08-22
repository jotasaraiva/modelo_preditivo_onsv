library(readxl)

quilometragem <- read_excel(
  "data-raw/quilometragem/Livro Segurança Viária - VF.xlsx",
  range = "C20:H32"
  )

colnames(quilometragem) <- c("ano","populacao","frota",
                             "quilometragem_10_bilhoes","mortes",
                             "internacoes")

quilometragem <- quilometragem |> 
  select(ano, quilometragem_10_bilhoes)

save(quilometragem, file = "data/quilometragem.rda")