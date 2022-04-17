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