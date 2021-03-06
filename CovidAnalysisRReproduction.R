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

### QUOTE DER INFIZIERTEN GEMESSEN AN BEV�LKERUNG DES LK

data[, Quote := AnzahlFall / Bev�.lkerung.insgesamt, by = key(data)]

### DATUM ALS SOLCHES FORMATTIEREN

data$datum <- as.Date(data$Refdatum)

### FALLZAHL NUMERISCH UND ID FAKTOR

data$AnzahlFall <- as.numeric(as.integer(data$AnzahlFall))
data$Prozentsatz.Infizierte <- as.numeric(as.factor(data$Prozentsatz.Infizierte))
data$IdLandkreis <- as.factor(as.integer(data$IdLandkreis))
data$AnzahlGenesen <- as.numeric(as.integer(data$AnzahlGenesen))
data$Bev�.lkerung.insgesamt <- as.numeric(as.integer(data$Bev�.lkerung.insgesamt))
data$Bev�.lkerung.m�.nnlich <- as.numeric(as.integer(data$Bev�.lkerung.m�.nnlich))
data$Bev�.lkerung.weiblich <- as.numeric(as.integer(data$Bev�.lkerung.weiblich))
data$Bev�.lkerung.je.km2 <- as.numeric(as.integer(data$Bev�.lkerung.je.km2))
data$DAQ.2019 <- as.numeric(as.character(data$DAQ.2019))
data$verf�.gbares.Einkommen.der.privaten.Haushalte..Mill..�... <- as.numeric(as.integer(data$verf�.gbares.Einkommen.der.privaten.Haushalte..Mill..�...))
data$verf�.g..Einkommen.der.priv..Haushalte.je.Einwohner..�... <- as.numeric(as.integer(data$verf�.g..Einkommen.der.priv..Haushalte.je.Einwohner..�...))

### PARTEIENWAEHLER IN RELATION ZU BEV�LKERUNG SETZEN

data$AfDrel <- data$AfD / data$W�.hler
data$CDUrel <- data$CDU / data$W�.hler
data$SPDrel <- data$SPD / data$W�.hler
data$FDPrel <- data$FDP / data$W�.hler
data$DIE.LINKErel <- data$DIE.LINKE / data$W�.hler
data$B�.ndnis.90.Die.Gr�.nenrel <- data$B�.ndnis.90.Die.Gr�.nen / data$W�.hler
data$PIRATENrel <- data$PIRATEN / data$W�.hler
data$Sonstige.Parteienrel <- data$Sonstige.Parteien / data$W�.hler

### IMPUTATION VON NAs

data$DAQ.2019[is.na(data$DAQ.2019)] <- round(mean(data$DAQ.2019, na.rm = TRUE))
data$DAQ <- data$DAQ.2019/data$Bev�.lkerung.insgesamt


### KORRELATIONSMATRIX F�R POLITISCHES MODEL

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
                       "B�.ndnis.90.Die.Gr�.nenrel",
                       "PIRATENrel",
                       "Sonstige.Parteienrel")]

cor(politmodel[, -c("IdLandkreis", "Landkreis", "datum")])

cor.test(politmodel$Quote, politmodel$AfDrel)
cor.test(politmodel$Quote, politmodel$CDUrel)
cor.test(politmodel$Quote, politmodel$SPDrel)
cor.test(politmodel$Quote, politmodel$FDPrel)
cor.test(politmodel$Quote, politmodel$DIE.LINKErel)
cor.test(politmodel$Quote, politmodel$B�.ndnis.90.Die.Gr�.nenrel)
cor.test(politmodel$Quote, politmodel$PIRATENrel)
cor.test(politmodel$Quote, politmodel$Sonstige.Parteienrel)

### KORRELATIONSMATRIX F�R SOZIODEMOGRAFISCHE FAKTOREN

sozmodel <- data[, c("IdLandkreis",
                     "Landkreis",
                     "datum",
                     "Quote", 
                     "AnzahlFall", 
                     "AnzahlGenesen", 
                     "Fl�.che..in.km2", 
                     "Bev�.lkerung.insgesamt", 
                     "Bev�.lkerung.m�.nnlich", 
                     "Bev�.lkerung.weiblich", 
                     "Bev�.lkerung.je.km2",
                     "DAQ",
                     "verf�.gbares.Einkommen.der.privaten.Haushalte..Mill..�...",
                     "verf�.g..Einkommen.der.priv..Haushalte.je.Einwohner..�...")]

cor(sozmodel[, -c("IdLandkreis", "Landkreis", "datum")])

cor.test(sozmodel$Quote, sozmodel$Fl�.che..in.km2)
cor.test(sozmodel$Quote, sozmodel$Bev�.lkerung.insgesamt)
cor.test(sozmodel$Quote, sozmodel$Bev�.lkerung.m�.nnlich)
cor.test(sozmodel$Quote, sozmodel$Bev�.lkerung.weiblich)
cor.test(sozmodel$Quote, sozmodel$Bev�.lkerung.je.km2)
cor.test(sozmodel$Quote, sozmodel$DAQ)
cor.test(sozmodel$Quote, sozmodel$verf�.gbares.Einkommen.der.privaten.Haushalte..Mill..�...)
cor.test(sozmodel$Quote, sozmodel$verf�.g..Einkommen.der.priv..Haushalte.je.Einwohner..�...)