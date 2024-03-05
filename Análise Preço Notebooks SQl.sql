-- Databricks notebook source
-- MAGIC %md
-- MAGIC
-- MAGIC **<h2> Projeto Análise de Preços Notebooks em SQL </h2>**
-- MAGIC
-- MAGIC
-- MAGIC Este pequeno projeto tem como intuito o estudo da análise de dados em SQL, utilizando a base de dados do Kaggle sobre os valores dos notebooks.
-- MAGIC Link base de dados: https://www.kaggle.com/datasets/kuchhbhi/latest-laptop-price-list

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **<h3> Análise Descritiva SQL </h3>**
-- MAGIC
-- MAGIC O SQL é uma ferramenta poderesoa para trabalhar com diferentes base de dados. Para quem trabalha com marketing e vendas é importante conhecer os 4 tipos de análise de dados. 
-- MAGIC Já que eles são fontes valiosas para insights e tomadas de decisões estratégicas. Nesse projeto iremos trabalhar com a análise descritiva e para isso vamos conhecer um pouco mais sobre ela:
-- MAGIC
-- MAGIC A análise descritiva é um método estatístico que envolve a <b> coleta, organização, interpretação, apresentação e descrição dos dados </b>. Ela fornece um resumo conciso dos dados de maneira quantitativa e é uma etapa crucial na análise de dados, pois ajuda a entender a natureza dos dados coletados.
-- MAGIC
-- MAGIC Por exemplo, em marketing e vendas, a análise descritiva pode ser usada para <b> calcular a média de vendas durante um determinado período, identificar o produto mais vendido, entender a distribuição de vendas por região, entre outros.</b>
-- MAGIC
-- MAGIC Exemplos de SQL para Análise Descritiva
-- MAGIC
-- MAGIC Aqui estão alguns exemplos simples de consultas SQL que podem ser usadas para análise descritiva:
-- MAGIC
-- MAGIC <b> Média de Vendas: Para calcular a média de vendas durante um determinado período, você pode usar a função AVG do SQL. </b>
-- MAGIC
-- MAGIC SELECT AVG(QuantidadeVendida) AS MediaVendas
-- MAGIC
-- MAGIC FROM TabelaVendas
-- MAGIC
-- MAGIC WHERE DataVenda BETWEEN '2023-01-01' AND '2023-12-31';
-- MAGIC
-- MAGIC

-- COMMAND ----------

select * from notebook_csv

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Aqui vamos mudar o preço das colunas **latest_price e old_price convertendo-os para o preço em real.**
-- MAGIC
-- MAGIC Nesse caso estamos utilizando o **alter view para não alterar a tabela original**.

-- COMMAND ----------

alter view view_notebook_csv
as select *,
ROUND(latest_price * 0.063, 5) AS latest_price_real,
ROUND(old_price * 0.063, 5) AS old_price_real
from notebook_csv

-- COMMAND ----------

select * from view_notebook_csv

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **<h3> Média de preço por marcas </h3>**
-- MAGIC
-- MAGIC Como vimos anteriormente, o cálculo de média de preço por marcas é uma análise importante para a análise descritiva. Vamos encontra-la!

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Vamos começar calculando a média de preços por marcas. Para isso será necessário 2 etapas:**
-- MAGIC
-- MAGIC **1º Utilizar uma função de agragação AVG**
-- MAGIC
-- MAGIC **2º Agrupar pelas marcas, no caso brand**

-- COMMAND ----------

-- Selecionamos a marca e realizamos o calculo da media com avg
select brand,
avg(latest_price_real) as media_price
from view_notebook_csv
-- Ao final agrupamos por marca do maior preço para o menor
group by brand
order by media_price desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **A consulta anterior funcionou, no entanto Lenovo ficou aparecendo 2x. Para isso podemos utilizar um tratamento de dados.**

-- COMMAND ----------

-- Selecionamos e utilizamos o case para o tratamento de dados
select 
case when brand = "lenovo" then "Lenovo"
     else brand
end as brand,
avg(latest_price_real) as media_price
from view_notebook_csv

-- precisamos agrupar em relação ao case para não ficar repetido o nome lenovo
group by 
case when brand = "lenovo" then "Lenovo"
     else brand
end
order by media_price desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Agora uma outra maneira de fazer essa query, para tornar a leitura mais limpa e direta.
-- MAGIC
-- MAGIC Nesse caso utilizei uma **subquery** para agrupar depois

-- COMMAND ----------

SELECT brand, AVG(latest_price_real) as media_price
-- Criando a subquery aqui, nesse caso é o mesmo procedimento anterior. Porém como uma subquery
FROM (
  SELECT 
    CASE 
      WHEN brand = 'lenovo' THEN 'Lenovo'
      ELSE brand
    END as brand,
    latest_price_real
  FROM view_notebook_csv
) 

AS subquery
GROUP BY brand
ORDER BY media_price DESC;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **<h3> Participações das mémorias (DDR3,DDR4,DDR5) nos PREÇOS</h3>**
-- MAGIC
-- MAGIC Outra análise descritiva importante é o tipo de memórias (DDR3,DDR4,DDR5) na **média dos preços**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Fazendo de maneira simples igual a media de preço por marcas, mas agora agrupando por **ram_type**

-- COMMAND ----------

select ram_type,
avg(latest_price_real) as media_price_ram
from view_notebook_csv
group by ram_type
order by media_price_ram desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Agora fazendo de uma maneira mais completa e também agrupando de maneira que não se repita**
-- MAGIC
-- MAGIC Esse agrupamento é interessante porque podemos unir os modelos ("LPDDR3", "LPDDR4", "LPDDR4X") apenas em DDR3 e DDR4

-- COMMAND ----------

-- Realizando o select e o case para o tratamento
SELECT
  CASE
  -- Quando as memorias foram do tipo  ("LPDDR3", "LPDDR4", "LPDDR4X") entre no 2º case
    WHEN ram_type IN ("LPDDR3", "LPDDR4", "LPDDR4X") THEN
      CASE
      -- Quando as memórias foram do tipo "LPDDR3" subs por DDR3
        WHEN ram_type = "LPDDR3" THEN "DDR3"
      -- Caso não, ou seja, "LPDDR4X" subs por DDR$
        ELSE "DDR4"
      END
    ELSE ram_type
  END AS ram_type,
  AVG(latest_price_real) AS media_price_ram
FROM view_notebook_csv

-- Agrupando para não ocorrer repitações
GROUP BY CASE
    WHEN ram_type IN ("LPDDR3", "LPDDR4", "LPDDR4X") THEN
      CASE
        WHEN ram_type = "LPDDR3" THEN "DDR3"
        ELSE "DDR4"
      END
    ELSE ram_type
  END 

ORDER BY media_price_ram DESC;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Memorias mais vendidas**
-- MAGIC
-- MAGIC Calcular as memórias mais vendidas é algo muito imporante para analisarmos a base
-- MAGIC
-- MAGIC **Nesse caso vamos utilizar a função agregadora sum()**

-- COMMAND ----------

-- Bem parecido com AVG(), porém utilizando a função sum()
SELECT
  CASE
    WHEN ram_type IN ("LPDDR3", "LPDDR4", "LPDDR4X") THEN
      CASE
        WHEN ram_type = "LPDDR3" THEN "DDR3"
        ELSE "DDR4"
      END
    ELSE ram_type
  END AS ram_type,
  sum(latest_price_real) AS sum_price_ram
FROM view_notebook_csv


GROUP BY CASE
    WHEN ram_type IN ("LPDDR3", "LPDDR4", "LPDDR4X") THEN
      CASE
        WHEN ram_type = "LPDDR3" THEN "DDR3"
        ELSE "DDR4"
      END
    ELSE ram_type
  END 

ORDER BY sum_price_ram DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Calculando a porcentagem de cada memória**
-- MAGIC
-- MAGIC Por último, calcular a **porcentagem de cada mémoria** em relação a base de dados é algo interessante também.
-- MAGIC Assim podemos estimar o quanto uma memória pode afetar o resultado final

-- COMMAND ----------

SELECT
  CASE
    WHEN ram_type IN ("LPDDR3", "LPDDR4", "LPDDR4X") THEN
      CASE
        WHEN ram_type = "LPDDR3" THEN "DDR3"
        ELSE "DDR4"
      END
    ELSE ram_type
  END AS ram_type,
  -- Aqui calculamos a procentagem das memorias em relação a base toda
  (COUNT(*) / (SELECT COUNT(*) FROM view_notebook_csv)) * 100 AS percentage
FROM view_notebook_csv

GROUP BY Case
    WHEN ram_type IN ("LPDDR3", "LPDDR4", "LPDDR4X") THEN
      CASE
        WHEN ram_type = "LPDDR3" THEN "DDR3"
        ELSE "DDR4"
      END
        ELSE ram_type
      END
ORDER BY percentage DESC;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC **<h3>Análise Final</h3>**
-- MAGIC
-- MAGIC Em relação a analise das mémorias podemos realizar algumas inferencias:
-- MAGIC
-- MAGIC A **memória DDR5 tem a maior média de preços**, isso indica que, em geral, as memórias DDR5 são mais caras do que as DDR4.
-- MAGIC
-- MAGIC No entanto, a memória DDR4 é a mais vendida e tem a maior participação na base de dados. Isso pode ser devido a vários fatores. Por exemplo, a **DDR4 pode ser mais popular** porque é mais antiga e mais compatível com dispositivos existentes. Além disso, mesmo que a DDR5 tenha um desempenho superior, o custo mais alto pode torná-la menos atraente para alguns consumidores. Portanto, embora a DDR5 seja mais cara, a DDR4 ainda domina o mercado devido à sua acessibilidade e compatibilidade.
-- MAGIC
-- MAGIC Mesmo que a memória DDR5 represente apenas **0.89% da base de dados**, o fato de ter a maior média de preço pode indicar que ela é mais lucrativa para a empresa.
-- MAGIC
-- MAGIC Isso sugere que, embora a empresa venda menos unidades de memória DDR5, a **margem de lucro por unidade** pode ser maior devido ao seu preço médio mais alto. Isso é especialmente verdadeiro se o custo de produção da memória DDR5 não for significativamente maior do que o da **DDR4**.
-- MAGIC
-- MAGIC No entanto, é importante lembrar que a lucratividade também pode depender de outros fatores, como o custo de produção, a demanda do mercado e a estratégia de preços da empresa
