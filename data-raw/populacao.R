enderecos_pop <- paste(
  "data-raw/populacao/",
  list.files("data-raw/populacao/"),
  sep = ""
)

import_pop <- function(endereco) {
  
  df1 <- read.dbf(endereco)
  
  df2 <- df1 |> 
    mutate(ano = as.numeric(as.character(ANO))) |>
    group_by(ano) |>
    summarise(populacao = sum(POPULACAO))
  
  return(df2)
}

arrange_pop <- function() {
  for (i in enderecos_pop) {
    
    if ("df_temp"|> exists()) {
      df_temp <- rbind(df_temp, import_pop(i))
    } else {
      df_temp <- import_pop(i)
    }
  }
  return(df_temp)
}

populacao <- arrange_pop()

save(populacao, file = "data/populacao.rda")