formatting = function(df, cols, num_cols){
  row_filter = apply(df, 1, function(z) sum(is.na(z)))
  df = df[row_filter < 3,]
  column_filter = apply(df, 2, function(z) sum(is.na(z)))
  df = df[, column_filter < 3]
  colnames(df) = cols
  df = df[-1, ]
  df %>%
    mutate(periodo = as.Date(periodo, format = "%d/%m/%y"),
           codigo = gsub("F$", "", codigo)) %>% 
    mutate_at(num_cols, as.numeric)
  
}

stock_events_treatment = function(x){
  x %>% 
    mutate_at("fator", as.numeric) %>% 
    mutate(data = as.Date(data))
}

create_log = function(df, df_events){
  df$fator = NA
  
  for (i in 1:nrow(df)){
    for (j in 1:nrow(df_events)){
      if (df$codigo[i] == df_events$codigo[j] & df$periodo[i] < df_events$data[j]){
        df$fator[i] = df_events$fator[j]
      }
    }
  }
  
  df = df %>% 
    mutate(fator = replace_na(fator, 1),
           quantidade = quantidade*fator) %>% 
    select(-fator)
  return(df)
}