{{
    config(
        materialized='view',
        tags=['intermediate', 'customers', 'metrics']
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
),

customer_metrics as (
    select
        customer_id,
        
        -- RFM Metrics
        max(order_date) as last_order_date,
        count(distinct order_id) as total_orders,
        sum(total_amount) as lifetime_value,
        avg(total_amount) as avg_order_value,
        
        -- Recency (days since last order)
        datediff(current_date(), max(order_date)) as days_since_last_order,
        
        -- Frequency segments
        case
            when count(distinct order_id) >= 10 then 'high'
            when count(distinct order_id) >= 5 then 'medium'
            else 'low'
        end as frequency_segment,
        
        -- Monetary segments
        case
            when sum(total_amount) >= 1000 then 'high_value'
            when sum(total_amount) >= 500 then 'medium_value'
            else 'low_value'
        end as monetary_segment
        
    from orders
    where status != 'cancelled'
    group by customer_id
)

select * from customer_metrics
