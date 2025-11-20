{{
    config(
        materialized='incremental',
        unique_key='date_day',
        partition_by=['year', 'month'],
        tags=['marts', 'fact', 'daily', 'incremental']
    )
}}

with orders as (
    select * from {{ ref('fct_orders') }}
    
    {% if is_incremental() %}
    where order_date >= (select max(date_day) from {{ this }})
    {% endif %}
),

daily_metrics as (
    select
        cast(order_date as date) as date_day,
        order_year as year,
        order_month as month,
        
        -- Order metrics
        count(distinct order_id) as total_orders,
        count(distinct customer_id) as unique_customers,
        sum(total_amount) as total_revenue,
        avg(total_amount) as avg_order_value,
        
        -- Status metrics
        sum(is_delivered) as delivered_orders,
        sum(is_cancelled) as cancelled_orders,
        
        -- Derived metrics
        {{ safe_divide('sum(is_delivered)', 'count(distinct order_id)') }} as delivery_rate,
        {{ safe_divide('sum(is_cancelled)', 'count(distinct order_id)') }} as cancellation_rate
        
    from orders
    group by 1, 2, 3
)

select * from daily_metrics
