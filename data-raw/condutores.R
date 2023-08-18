enderecos_condutores <- paste(
  "data-raw/condutores/",
  list.files("data-raw/condutores/"),
  sep = ""
)

import_cnh <- function(endereco) {
  
  df <- read_excel(
    endereco,
    range = cell_cols("N:"),
    sheet = 1
  )
  
  if (colnames(df) != "Total") {
    df <- read_excel(
      endereco,
      range = cell_cols("S:"),
      sheet = 1
    )
  }
  
  df <- df |> rename(condutores = Total)
  qtde_condutores <- last(df)
  
  qtde_condutores |>
    mutate(
      ano = as.numeric(str_sub(endereco, 44, 47)),
      condutores = as.numeric(condutores)
    )
}

extract_cnh <- function() {
  for (i in enderecos_condutores) {
    if ("n_condutores" |> exists()) {
      n_condutores <- rbind(n_condutores, import_cnh(i))
    }
    else {
      n_condutores <- import_cnh(i)
    }
  }
  return(n_condutores)
}

tabela_condutores <- extract_cnh()

save(tabela_condutores, file = "data/tabela_condutores.rda")