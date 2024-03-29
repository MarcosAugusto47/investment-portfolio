library(dplyr)
library(tidyr)
library(readxl)
library(stringr)
source("utils/binance_log_functions.R")
df = read.csv("data/bronze/cryptocurrency/binance.csv")
df = binance_extract_treatment(df)
write.csv(df, "data/silver/binance_log.csv", row.names = FALSE)
