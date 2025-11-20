{{
    config(
        materialized='table',
        tags=['marts', 'dimension', 'customers']
    )
}}

with customers as (
    select * from {{ ref('stg_customers') }}
),

metrics as (
    select * from {{ ref('int_customer_metrics') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }} as customer_key,
        c.customer_id,
        c.customer_name,
        c.email,
        c.country,
        
        -- Metrics
        coalesce(m.total_orders, 0) as total_orders,
        coalesce(m.lifetime_value, 0) as lifetime_value,
        coalesce(m.avg_order_value, 0) as avg_order_value,
        m.last_order_date,
        m.days_since_last_order,
        m.frequency_segment,
        m.monetary_segment,
        
        -- SCD Type 2 fields
        current_timestamp() as valid_from,
        cast(null as timestamp) as valid_to,
        true as is_current
        
    from customers c
    left join metrics m on c.customer_id = m.customer_id
)

select * from final
