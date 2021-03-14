### MERGED DATA ANALYSIS

setwd("C:/Users/Can/Desktop/TechLabs/Covid_Projekt")

library(ggplot2)
library(dplyr)
library(data.table)
library(ggplot2)
library(plm)
library("Hmisc")
library("tidyselect")



### DATENSATZ EINLESEN

Rohdaten <- read.csv("merged_data_new - merged_data_new.csv")

### FORMATTIERUNG IN DATATABLE

data <- data.table(Rohdaten, key = "IdLandkreis")

### QUOTE DER INFIZIERTEN GEMESSEN AN BEVÖLKERUNG DES LK

data[, Quote := AnzahlFall / BevÃ.lkerung.insgesamt, by = key(data)]

### DATUM ALS SOLCHES FORMATTIEREN

data$datum <- as.Date(data$Refdatum)

### FALLZAHL NUMERISCH UND ID FAKTOR

data$AnzahlFall <- as.numeric(as.integer(data$AnzahlFall))
data$Prozentsatz.Infizierte <- as.numeric(as.factor(data$Prozentsatz.Infizierte))
data$IdLandkreis <- as.factor(as.integer(data$IdLandkreis))
data$AnzahlGenesen <- as.numeric(as.integer(data$AnzahlGenesen))
data$BevÃ.lkerung.insgesamt <- as.numeric(as.integer(data$BevÃ.lkerung.insgesamt))
data$BevÃ.lkerung.mÃ.nnlich <- as.numeric(as.integer(data$BevÃ.lkerung.mÃ.nnlich))
data$BevÃ.lkerung.weiblich <- as.numeric(as.integer(data$BevÃ.lkerung.weiblich))
data$BevÃ.lkerung.je.km2 <- as.numeric(as.integer(data$BevÃ.lkerung.je.km2))
data$DAQ.2019 <- as.numeric(as.character(data$DAQ.2019))
data$verfÃ.gbares.Einkommen.der.privaten.Haushalte..Mill..â... <- as.numeric(as.integer(data$verfÃ.gbares.Einkommen.der.privaten.Haushalte..Mill..â...))
data$verfÃ.g..Einkommen.der.priv..Haushalte.je.Einwohner..â... <- as.numeric(as.integer(data$verfÃ.g..Einkommen.der.priv..Haushalte.je.Einwohner..â...))

### PARTEIENWAEHLER IN RELATION ZU BEVÖLKERUNG SETZEN

data$AfDrel <- data$AfD / data$WÃ.hler
data$CDUrel <- data$CDU / data$WÃ.hler
data$SPDrel <- data$SPD / data$WÃ.hler
data$FDPrel <- data$FDP / data$WÃ.hler
data$DIE.LINKErel <- data$DIE.LINKE / data$WÃ.hler
data$BÃ.ndnis.90.Die.GrÃ.nenrel <- data$BÃ.ndnis.90.Die.GrÃ.nen / data$WÃ.hler
data$PIRATENrel <- data$PIRATEN / data$WÃ.hler
data$Sonstige.Parteienrel <- data$Sonstige.Parteien / data$WÃ.hler

### IMPUTATION VON NAs

data$DAQ.2019[is.na(data$DAQ.2019)] <- round(mean(data$DAQ.2019, na.rm = TRUE))
data$DAQ <- data$DAQ.2019/data$BevÃ.lkerung.insgesamt


### KORRELATIONSMATRIX FÜR POLITISCHES MODEL

politmodel <- data[, c("IdLandkreis",
                       "Landkreis", 
                       "datum",
                       "Quote", 
                       "AnzahlFall", 
                       "AnzahlGenesen", 
                       "AfDrel", 
                       "CDUrel", 
                       "SPDrel", 
                       "FDPrel", 
                       "DIE.LINKErel",
                       "BÃ.ndnis.90.Die.GrÃ.nenrel",
                       "PIRATENrel",
                       "Sonstige.Parteienrel")]

cor(politmodel[, -c("IdLandkreis", "Landkreis", "datum")])

cor.test(politmodel$Quote, politmodel$AfDrel)
cor.test(politmodel$Quote, politmodel$CDUrel)
cor.test(politmodel$Quote, politmodel$SPDrel)
cor.test(politmodel$Quote, politmodel$FDPrel)
cor.test(politmodel$Quote, politmodel$DIE.LINKErel)
cor.test(politmodel$Quote, politmodel$BÃ.ndnis.90.Die.GrÃ.nenrel)
cor.test(politmodel$Quote, politmodel$PIRATENrel)
cor.test(politmodel$Quote, politmodel$Sonstige.Parteienrel)

### KORRELATIONSMATRIX FÜR SOZIODEMOGRAFISCHE FAKTOREN

sozmodel <- data[, c("IdLandkreis",
                     "Landkreis",
                     "datum",
                     "Quote", 
                     "AnzahlFall", 
                     "AnzahlGenesen", 
                     "FlÃ.che..in.km2", 
                     "BevÃ.lkerung.insgesamt", 
                     "BevÃ.lkerung.mÃ.nnlich", 
                     "BevÃ.lkerung.weiblich", 
                     "BevÃ.lkerung.je.km2",
                     "DAQ",
                     "verfÃ.gbares.Einkommen.der.privaten.Haushalte..Mill..â...",
                     "verfÃ.g..Einkommen.der.priv..Haushalte.je.Einwohner..â...")]

cor(sozmodel[, -c("IdLandkreis", "Landkreis", "datum")])

cor.test(sozmodel$Quote, sozmodel$FlÃ.che..in.km2)
cor.test(sozmodel$Quote, sozmodel$BevÃ.lkerung.insgesamt)
cor.test(sozmodel$Quote, sozmodel$BevÃ.lkerung.mÃ.nnlich)
cor.test(sozmodel$Quote, sozmodel$BevÃ.lkerung.weiblich)
cor.test(sozmodel$Quote, sozmodel$BevÃ.lkerung.je.km2)
cor.test(sozmodel$Quote, sozmodel$DAQ)
cor.test(sozmodel$Quote, sozmodel$verfÃ.gbares.Einkommen.der.privaten.Haushalte..Mill..â...)
cor.test(sozmodel$Quote, sozmodel$verfÃ.g..Einkommen.der.priv..Haushalte.je.Einwohner..â...)