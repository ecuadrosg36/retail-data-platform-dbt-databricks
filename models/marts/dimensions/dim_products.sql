{{
    config(
        materialized='table',
        tags=['marts', 'dimension', 'products']
    )
}}

with products as (
    select * from {{ ref('stg_products') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
        product_id,
        product_name,
        category,
        price,
        
        -- Categorization
        case
            when price < 50 then 'budget'
            when price < 200 then 'mid-range'
            else 'premium'
        end as price_tier,
        
        current_timestamp() as created_at
        
    from products
)

select * from final
