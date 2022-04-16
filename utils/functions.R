formatting = function(df, cols, num_cols){
    row_filter = apply(df, 1, function(z) sum(is.na(z)))
    df = df[row_filter < 3,]
    column_filter = apply(df, 2, function(z) sum(is.na(z)))
    df = df[, column_filter < 3]
    colnames(df) = cols
    df = df[-1, ]
    df %>%
      mutate(periodo = as.Date(periodo, format = "%d/%m/%y")) %>% 
      mutate_at(num_cols, as.numeric)
}

buys_data_treatment = function(x){
  x %>%
    mutate(codigo = gsub("F$", "", codigo)) %>%
    filter(c_v == "C") %>%
    group_by(codigo) %>%
    summarise(quantidade_total = sum(quantidade),
              valor_pago_total = sum(valor_total)) %>%
    mutate(preco_medio = round(valor_pago_total / quantidade_total, 2))
}

compute_position = function(x){
 x %>%
   mutate(codigo = gsub("F$", "", codigo)) %>%
   group_by(codigo, c_v) %>%
   summarise(quantidade_total = sum(quantidade)) %>%
   pivot_wider(names_from = c_v, values_from = quantidade_total) %>%
   mutate(V = replace_na(V, 0),
          C = replace_na(C, 0),
          posicao = C-V)
}

data_join = function(df1, df2){
  df1 %>% 
    full_join(df2, by = "codigo") %>% 
    select(codigo, valor_pago_total, preco_medio, C, V, posicao) 
    
}

stock_events_treatment = function(x){
  x %>% 
    mutate_at("fator", as.numeric)
}

join_stock_events = function(df1, df2){
  df1 %>% 
    left_join(df2, by = 'codigo') %>% 
    mutate(fator = replace_na(fator, 1)) %>% 
    select(-data)
}

update_positions = function(x){
 x %>%
    mutate(posicao = posicao*fator,
           preco_medio = preco_medio/fator)
}

final_join = function(df1, df2){
  df1 %>% select(-c("evento")) %>% 
    full_join(df2, by = 'codigo') %>% 
    replace(is.na(.), 0) %>% 
    mutate(custo_total_final = valor_pago_total.x + valor_pago_total.y,
           posicao_final = posicao.x + posicao.y,
           preco_medio_final = round(custo_total_final/posicao_final, 2)) %>% 
    select(codigo, custo_total_final, posicao_final, preco_medio_final)
  
}
