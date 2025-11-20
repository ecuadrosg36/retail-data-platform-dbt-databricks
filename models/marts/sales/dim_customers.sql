{{ config(materialized='table') }}

select
  {{ generate_surrogate_key(["customer_id", "country"]) }} as customer_key,
  c.customer_id,
  c.customer_name,
  c.email,
  c.country,
  coalesce(i.orders_count, 0) as orders_count,
  coalesce(i.sales_amount, 0) as sales_amount,
  i.first_order,
  i.last_order
from {{ ref('stg_customers') }} c
left join {{ ref('int_customer_orders') }} i
  on c.customer_id = i.customer_id
