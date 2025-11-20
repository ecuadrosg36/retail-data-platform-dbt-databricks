{{
    config(
        materialized='table',
        tags=['marts', 'fact', 'orders']
    )
}}

with enriched_orders as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_key,
        order_id,
        customer_id,
        product_id,
        order_date,
        status,
        total_amount,
        
        -- Date components for partitioning
        year(order_date) as order_year,
        month(order_date) as order_month,
        dayofweek(order_date) as order_day_of_week,
        
        -- Flags
        case when status = 'delivered' then 1 else 0 end as is_delivered,
        case when status = 'cancelled' then 1 else 0 end as is_cancelled,
        
        current_timestamp() as _created_at
        
    from enriched_orders
)

select * from final
