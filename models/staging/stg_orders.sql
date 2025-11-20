{{
    config(
        materialized='view',
        tags=['staging', 'orders']
    )
}}

with source as (
    select * from {{ source('raw_retail', 'raw_orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        lower(trim(status)) as status,
        cast(total_amount as decimal(10,2)) as total_amount,
        current_timestamp() as _loaded_at
    from source
)

select * from renamed
