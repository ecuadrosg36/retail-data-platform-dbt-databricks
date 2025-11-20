{{ config(materialized='table') }}

select
  d.order_id,
  d.customer_id,
  c.country,
  d.product_id,
  d.category,
  sum(d.order_amount)              as total_sales,
  count(distinct d.order_id)       as num_orders,
  min(d.order_date)                as first_order,
  max(d.order_date)                as last_order
from {{ ref('int_order_details') }} d
left join {{ ref('stg_customers') }} c
  on d.customer_id = c.customer_id
group by 1,2,3,4,5
