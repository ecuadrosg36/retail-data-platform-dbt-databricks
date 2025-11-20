{{
    config(
        materialized='view',
        tags=['intermediate', 'orders']
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

enriched as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status,
        o.total_amount,
        
        -- Customer info
        c.customer_name,
        c.email,
        c.country,
        
        -- Product info (assuming one product per order for simplicity)
        p.product_id,
        p.product_name,
        p.category as product_category,
        p.price as product_price
        
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join products p on o.order_id = p.product_id  -- Simplified join
)

select * from enriched
