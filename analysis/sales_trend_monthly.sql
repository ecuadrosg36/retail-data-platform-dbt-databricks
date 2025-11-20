select
  date_trunc('month', first_order) as month,
  sum(total_sales) as sales
from {{ ref('fct_sales') }}
group by 1
order by month asc
