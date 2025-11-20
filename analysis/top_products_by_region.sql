select
  country,
  category,
  product_id,
  sum(total_sales) as sales
from {{ ref('fct_sales') }}
group by 1,2,3
order by sales desc
limit 50
