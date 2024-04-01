library(foreign)

anos <- seq(1997,2021,1)

download_datasus_ibge <- function(intervalo){
  
  intervalo <- intervalo |> as.character() |> str_sub(3,4)
  
  for(i in intervalo){
    endereco <- paste("ftp://ftp.datasus.gov.br/dissemin/publicos/IBGE/POPTCU/POPTBR",i,".zip",sep = "")
    destino <- paste("data-raw/populacao_zip/",i,".zip",sep = "")
    
    # download
    download.file(endereco, destfile = destino)
    
    #unzip
    unzip(destino, exdir = "data-raw/populacao_zip/")
  }
  
}

move_datasus_files <- function(intervalo){
  
  for(i in intervalo){
    
    j <- i |> as.character() |> str_sub(3,4)
    
    #endereços
    endereco <- paste("data-raw/populacao_zip/POPTBR",j,".DBF",sep = "")
    destino <- paste("data-raw/populacao/POPTBR",i,".DBF",sep = "")
    
    #copiar para nova pasta
    file.copy(from = endereco, to = destino)
  }
  
}

download_datasus_ibge(anos)
move_datasus_files(anos)

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

populacao <- arrange_pop() |> 
  rbind(data.frame(
    populacao = c(203080756, 203080756),
    ano = c(2022, 2023)
  ))

save(populacao, file = "data/populacao.rda")