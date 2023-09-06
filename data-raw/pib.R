endereco_pib <- "data-raw/pib/tabela2072.xlsx"

import_pib <- function(path) {
  municipios <- read_excel(path) |> 
    drop_na() |> 
    slice(-1)
  
  colnames(municipios) <- c("trim_ano", "pib")
  
  municipios <- municipios |> 
    mutate(
      ano = str_sub(trim_ano,14,17) |> as.numeric(),
      trim = str_sub(trim_ano,1,1) |> as.numeric(),
      total = pib |> as.numeric()
    ) |> 
    group_by(ano) |> 
    summarise(pib = sum(total))
  
  return(municipios)
}

pib <- import_pib(endereco_pib)

save(pib, file = "data/pib.rda")