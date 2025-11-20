with base as (
  select customer_id, sum(total_sales) as revenue
  from {{ ref('fct_sales') }}
  group by 1
)
select
  customer_id,
  revenue,
  case
    when revenue >= 10000 then 'VIP'
    when revenue >= 5000  then 'Gold'
    when revenue >= 1000  then 'Silver'
    else 'Bronze'
  end as customer_tier
from base
order by revenue desc
