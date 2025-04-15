rm(list = ls())
cat("\014")
library(data.table)
library(tidyverse)
df1 <- fread("Tidyverse/dados/202401_Cadastro.csv", dec = ",", encoding = "Latin-1")
df2 <- fread("Tidyverse/dados/202401_Remuneracao.csv", dec = ",", encoding = "Latin-1")
names(df2)
dfCad <- df1 %>% filter(DESCRICAO_CARGO=="JUIZ DO TRIBUNAL MARITIMO")
dfRem <- df1
df2$DATA_INGRESSO_ORGAO <- as.Date(as.character(df2$DATA_INGRESSO_ORGAO), format = "%d/%m/%Y")
#Apagar Espacos antes e apos o texto
df2$NOME <- str_trim(df2$NOME)
df2$DESCRICAO_CARGO <- str_trim(df2$DESCRICAO_CARGO)
df2$ORG_LOTACAO     <- str_trim(df2$ORG_LOTACAO)
df2$ORG_EXERCICIO   <- str_trim(df2$ORG_EXERCICIO)
df2$REGIME_JURIDICO <- str_trim(df2$REGIME_JURIDICO)
df2$SITUACAO_VINCULO<- str_trim(df2$SITUACAO_VINCULO)
#Transformar as letras em maiusculas
df2$NOME            <- str_to_upper(df2$NOME)
df2$DESCRICAO_CARGO <- str_to_upper(df2$DESCRICAO_CARGO)
df2$ORG_LOTACAO     <- str_to_upper(df2$ORG_LOTACAO)
df2$ORG_EXERCICIO   <- str_to_upper(df2$ORG_EXERCICIO)
df2$REGIME_JURIDICO <- str_to_upper(df2$REGIME_JURIDICO)
df2$SITUACAO_VINCULO<- str_to_upper(df2$SITUACAO_VINCULO)
#Remover acentos desnecessarios
df2$NOME            <- abjutils::rm_accent(df2$NOME)
df2$DESCRICAO_CARGO <- abjutils::rm_accent(df2$DESCRICAO_CARGO)
df2$ORG_LOTACAO     <- abjutils::rm_accent(df2$ORG_LOTACAO)
df2$ORG_EXERCICIO   <- abjutils::rm_accent(df2$ORG_EXERCICIO)
df2$REGIME_JURIDICO <- abjutils::rm_accent(df2$REGIME_JURIDICO)
df2$SITUACAO_VINCULO<- abjutils::rm_accent(df2$SITUACAO_VINCULO)

#df2<- df2[grep("PROFESSOR|SUBSTITUTO|PROF ENS BAS TEC TECNOLOGICO-SUBSTITUTO|PROF DO ENSINO BASICO TEC TECNOLOGICO", df2$DESCRICAO_CARGO), ]
df2 <- df2 %>% select("Id_SERVIDOR_PORTAL",
                      "NOME", 
                      "CPF", 
                      "DESCRICAO_CARGO",
                      "SITUACAO_VINCULO", 
                      "DATA_INGRESSO_ORGAO" ,
                      "ORG_LOTACAO",
                      "ORG_EXERCICIO",
                      "REGIME_JURIDICO")


df2 <- merge(dfCad, df2, by="Id_SERVIDOR_PORTAL")

teste <- data.frame(unique(df1$DESCRICAO_CARGO))

