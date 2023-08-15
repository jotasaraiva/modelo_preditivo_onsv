library(tidyverse)

anos <- seq(2006,2021,1)

download_datasus_ibge <- function(intervalo){
  
  intervalo <- intervalo |> as.character() |> str_sub(3,4)
  
  for(i in intervalo){
    endereco <- paste("ftp://ftp.datasus.gov.br/dissemin/publicos/IBGE/POPTCU/POPTBR",i,".zip",sep = "")
    destino <- paste("dados_pop/pop",i,".zip",sep = "")
    
    # download
    download.file(endereco, destfile = destino)

    #unzip
    unzip(destino, exdir = "dados_pop/")
  }
  
}

move_datasus_files <- function(intervalo){
  
  for(i in intervalo){
    
    j <- i |> as.character() |> str_sub(3,4)
    
    #endereços
    endereco <- paste("dados_pop/POPTBR",j,".DBF",sep = "")
    destino <- paste("dados_pop/poptcu/POPTBR",i,".DBF",sep = "")
      
    #copiar para nova pasta
    file.copy(from = endereco, to = destino)
  }
  
}

download_datasus_ibge(anos)
move_datasus_files(anos)

