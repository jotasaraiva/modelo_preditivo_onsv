enderecos_frota <- paste(
  "data-raw/frotas2000_2021/",
  list.files("data-raw/frotas2000_2021/"),
  sep = ""
)

import_frota <- function(endereco) {
  frota <- tryCatch(
    read_excel(endereco, sheet = 2, range = "B41:W42"),
    error = function(e) {
      if (str_sub(endereco, 31, 34) %in% c("2005","2004")) {
        aux <- read_excel(endereco, sheet = 1, range = "B42:W43")
        nomes <- aux |>
          colnames() |>
          toupper() 
        nomes <- replace(nomes, nomes %in% "UTILITARIO", "UTILITÁRIO")
        colnames(aux) <- nomes
        return(aux)
      } else if (str_sub(endereco, 31, 34) == "2003") {
        # precisou alterar o formato da planilha de .xls para .xlsx 
        # e excluir páginas vazias
        # também é feito um subset da planilha para coletar só os totais
        aux <- read_excel(endereco, sheet = 1, range = "B3:W33")
        return(aux[nrow(aux), ])
      } else if (str_sub(endereco, 31, 34) == "2002") {
        aux <- read_excel(endereco, sheet = 1, range = "B7:W38")
        colnames(aux) <- c(
          "TOTAL", "AUTOMÓVEL", "BONDE", "CAMINHÃO", "CAMINHÃO TRATOR",
          "CAMINHONETE", "CAMIONETA", "CHASSI PLATAF", "CICLOMOTOR", "MICROÔNIBUS",
          "MOTOCICLETA", "MOTONETA", "ÔNIBUS", "QUADRICICLO", "REBOQUE",
          "SEMIREBOQUE", "SIDECAR", "OUTROS", "TRATOR ESTEI", "TRATOR RODAS",
          "TRICICLO","UTILITÁRIO")
        return(aux[nrow(aux), ])
      } else if (str_sub(endereco, 31, 34) == "2001") {
        aux <- read_excel(endereco, sheet = 1, range = "B36:W38")
        return(aux[nrow(aux), ])
      } else if (str_sub(endereco, 31, 34) == "2000") {
        aux <- read_excel(endereco, sheet = 1, range = "B36:W37")
        return(aux[nrow(aux), ])
      } else {
        return(read_excel(endereco, sheet = 1, range = "B41:W42"))
      }
    }
  )
  return(frota)
}

frota_extract <- function(df) {
  # transforma dados em númerico caso estejam em formato de carácter
  df_temp <- as.data.frame(lapply(df, as.numeric))
  
  res <- df_temp |> 
    mutate(
      automovel = AUTOMÓVEL + CAMINHONETE + CAMIONETA + UTILITÁRIO,
      motocicleta = MOTOCICLETA + MOTONETA + CICLOMOTOR,
      total = TOTAL
    ) |> 
    select(
      automovel,
      motocicleta,
      total
    )
  
  return(res)
}

arrange_frota <- function() {
  for(i in enderecos_frota) {
    if ("frota_anos" |> exists()) {
      frota_anos <- rbind(frota_anos, frota_extract(import_frota(i)))
      anos <- append(anos, i |> str_sub(31,34) |> as.numeric())
    }
    else {
      frota_anos <- import_frota(i) |> frota_extract()
      anos <- i |> str_sub(31,34) |> as.numeric()
    }
  }
  
  frota_anos <- as_tibble(frota_anos)
  
  frota_anos$anos <- anos
  return(frota_anos)
}

frota_veiculos <- arrange_frota()

save(frota_veiculos, file = "data/frota_veiculos.rda")