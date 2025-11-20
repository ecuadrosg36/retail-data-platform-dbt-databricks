{{ config(materialized='view') }}

select
  o.customer_id,
  count(distinct o.order_id) as orders_count,
  sum(o.order_amount)        as sales_amount,
  min(o.order_date)          as first_order,
  max(o.order_date)          as last_order
from {{ ref('stg_orders') }} o
group by 1
