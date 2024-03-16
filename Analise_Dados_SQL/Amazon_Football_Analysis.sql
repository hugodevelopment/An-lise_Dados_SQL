-- Databricks notebook source
-- MAGIC %md
-- MAGIC <h3>Análise Descritiva Amazon DataSet </h3>
-- MAGIC
-- MAGIC As análises deste pequeno projeto tem como objetivo demostrar e praticar as habilidades em análise de dados e SQL com o dataset da Amazon presente no Kaggle:
-- MAGIC Link: https://www.kaggle.com/datasets/lokeshparab/amazon-products-dataset
-- MAGIC
-- MAGIC Como o dataset tem muitos arquivos, resolvi analisar um arquivo sobre produtos de futebol.
-- MAGIC
-- MAGIC O dataset original continha muitas linhas nulas e com textos nas colunas de preços, para resolver isso manipulei com python para limpar e tratar os dados.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC import pandas as pd
-- MAGIC
-- MAGIC df = pd.read_csv('Football.csv', sep=";")
-- MAGIC df
-- MAGIC
-- MAGIC df = df.dropna(subset=['ratings'])
-- MAGIC df
-- MAGIC
-- MAGIC df['ratings'] = pd.to_numeric(df['ratings'], errors='coerce')
-- MAGIC df
-- MAGIC
-- MAGIC df.to_csv('foot.csv', index=False)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Agora com os dados limpos podemos fazer a análise**

-- COMMAND ----------

select * from foot_2_csv

-- COMMAND ----------

-- MAGIC %md
-- MAGIC As análises SQL que propus são projetadas para fornecer insights valiosos que podem melhorar a experiência do cliente e impulsionar o sucesso dos negócios na Amazon.
-- MAGIC
-- MAGIC **Média de Avaliações por Categoria:** Ao calcular a média de avaliações para cada categoria, podemos identificar quais categorias estão se saindo bem e quais podem precisar de melhorias. Isso pode nos ajudar a entender melhor as preferências dos clientes e aprimorar a qualidade dos produtos em categorias com avaliações mais baixas.
-- MAGIC
-- MAGIC **Total de Avaliações por Produto:** Ao calcular o número total de avaliações para cada produto, podemos identificar quais produtos são mais populares entre os clientes. Isso pode nos ajudar a gerenciar nosso estoque de forma mais eficaz e garantir que os produtos populares estejam sempre disponíveis para os clientes.
-- MAGIC Produtos com Maior Desconto: Ao encontrar os produtos com o maior desconto, podemos identificar quais produtos oferecem o melhor valor para os clientes. Isso pode nos ajudar a atrair mais clientes e aumentar as vendas.
-- MAGIC
-- MAGIC **Produtos Mais Caros e Mais Baratos:** Ao identificar os produtos mais caros e mais baratos em cada categoria, podemos entender melhor a faixa de preços dos nossos produtos. Isso pode nos ajudar a definir estratégias de preços mais eficazes e garantir que oferecemos produtos a preços competitivos.
-- MAGIC Contagem de Produtos por Categoria: Ao contar o número de produtos em cada categoria, podemos entender melhor a distribuição dos nossos produtos. Isso pode nos ajudar a identificar quais categorias podem precisar de mais variedade de produtos.
-- MAGIC
-- MAGIC Essas análises podem nos ajudar a descobrir e resolver problemas do mundo real, construir métricas significativas e desenvolver casos de negócios sólidos. Ao fazer isso, podemos melhorar continuamente a experiência do cliente e impulsionar o sucesso dos negócios na Amazon.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Produtos com maiores rating**

-- COMMAND ----------

select name,
max(ratings) as rating
from foot_2_csv
-- Ao final agrupamos por marca do maior preço para o menor
group by name
order by rating desc
limit 15

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Produtos com menores rating**

-- COMMAND ----------

select name,
min(ratings) as rating
from foot_2_csv
-- Ao final agrupamos por marca do maior preço para o menor
group by name
order by rating asc
limit 15

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Produtos mais caros**

-- COMMAND ----------

select name,
max(actual_price) as price
from foot_2_csv
group by name
order by price desc
limit 15

-- COMMAND ----------

SELECT name, MIN(actual_price) as price
FROM foot_2_csv
WHERE actual_price IS NOT NULL
GROUP BY name
ORDER BY price ASC
limit 10


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Produtos com maiores descontos**

-- COMMAND ----------

SELECT name, Max(discount_price) as maior_desconto
FROM foot_2_csv
WHERE discount_price IS NOT NULL
GROUP BY name
ORDER BY maior_desconto DESC
limit 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Produtos mais ratings**

-- COMMAND ----------

SELECT name, SUM(no_of_ratings) as total_ratings
FROM foot_2_csv
GROUP BY name
ORDER BY total_ratings DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Conclusão**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Com base nas análises SQL propostas e na discussão anterior, podemos concluir que a manipulação e análise de dados são ferramentas poderosas que podem fornecer insights valiosos para aprimorar a experiência do cliente e impulsionar o sucesso dos negócios.
-- MAGIC
-- MAGIC Ao analisar as avaliações, o número total de avaliações, os descontos, os preços e a contagem de produtos por categoria, podemos identificar tendências, padrões e áreas de melhoria. Essas informações podem nos ajudar a tomar decisões informadas, resolver problemas do mundo real e desenvolver estratégias eficazes.
-- MAGIC
-- MAGIC Além disso, ao limpar os dados e lidar com valores nulos ou não numéricos, podemos garantir a precisão e a confiabilidade de nossas análises. Isso é crucial para obter resultados significativos e fazer previsões precisas.
-- MAGIC
-- MAGIC Em última análise, essas análises podem nos ajudar a melhorar continuamente a experiência do cliente, otimizar nossas operações e alcançar nossos objetivos de negócios. 😊
