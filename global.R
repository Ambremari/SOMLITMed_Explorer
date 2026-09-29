library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(lubridate)
library(shinycssloaders)
library(cowplot)
library(ggExtra)
library(stringr)
library(ggpubr)


preprocess_data <- function(data, months_as_factor = TRUE){
  if("DATE" %in% colnames(data)){
    data$DATE <- ymd(data$DATE)
    if(!("ANNEE" %in% colnames(data))){
      data <- data %>% mutate(ANNEE= year(DATE), 
                              MOIS=month(DATE),
                              JOUR=yday(DATE))
    }
    data$ANNEE <- factor(data$ANNEE)
  }
  if("MOIS" %in% colnames(data) & months_as_factor){
    data$MOIS <- factor(data$MOIS,
                        levels=c("All", 1:12),
                        labels=c('All', 'Jan', 'Feb', 'Mar', 'Apr', 
                                 'May', 'Jun', 'Jul', 'Aug', 
                                 'Sep', 'Oct', 'Nov', 'Dec'))
  }
  if("ID_SITE" %in% colnames(data)){
    data$ID_SITE <- factor(data$ID_SITE,
                           levels=c(10, 11, 12),
                           labels=c('Banyuls', 'Marseille', 'Villefranche'))
  }
  return(data)
}

my_palette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


# variables 
stations <- levels(factor(levels=c(10, 11, 12),
                          labels=c('Banyuls', 'Marseille', 'Villefranche')))
months <- c('Jan', 'Feb', 'Mar', 'Apr', 
            'May', 'Jun', 'Jul', 'Aug', 
            'Sep', 'Oct', 'Nov', 'Dec')

piconano_columns <- c("SYNC", "PROC", "NANOEC", "PICOEC", "CRYC", "HNABACC", "LNABACC", "SYNSSC", "PROSSC", "NANOESSC", "PICOESSC", "CRYSSC", "HNABACSSC", "LNABACSSC")

hydro_columns <- c("T", "S", "NH4", "NO2", "SIOH4", "PO4", "PC2_TEMPERATURE", "CHLA")

piconano_labels <- c("OraPicoProk", "RedPicoProk", "RedPico", "OraNano", "RedNano",
                     "OraPicoProkSSC", "RedPicoProkSSC", "RedPicoSSC", "OraNanoSSC", "RedNanoSSC",
                     "OraPicoProkFLR", "RedPicoProkFLR", "RedPicoFLR", "OraNanoFLR", "RedNanoFLR",
                     "Chl a", "TotalHet", "HetHNA", "HetLNA", "HetHNASSC", "HetLNASSC")

piconano_names <- c("SYNC", "PROC", "PICOEC", "CRYC", "NANOEC", 
                    "SYNSSC", "PROSSC", "PICOESSC", "CRYSSC", "NANOESSC",
                    "SYNFLR", "PROFLR", "PICOEFLR", "CRYFLR", "NANOEFLR",
                    "CHLA", "TBACC", "HNABACC", "LNABACC", "HNABACSSC", "LNABACSSC")

names(piconano_labels) <- piconano_names


# Load data 

#raw
ts_hydro <- read.csv("data/somlit_time_series_df.csv")


#hydro
raw_hydro_data <- ts_hydro[, c("ID_SITE", "DATE", hydro_columns)]
raw_hydro_data <- preprocess_data(raw_hydro_data)
hydro_data <- raw_hydro_data

#hydro
raw_piconano_data <- ts_hydro[, c("ID_SITE", "DATE", piconano_columns)]
raw_piconano_data <- preprocess_data(raw_piconano_data)
colnames(raw_piconano_data)[match(piconano_columns, colnames(raw_piconano_data))] <-
  unname(piconano_labels[piconano_columns])

piconano_data <- raw_piconano_data


choices_piconano <- sort(piconano_labels[piconano_columns])


