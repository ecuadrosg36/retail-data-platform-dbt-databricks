{{
    config(
        materialized='view',
        tags=['staging', 'customers']
    )
}}

with source as (
    select * from {{ source('raw_retail', 'raw_customers') }}
),

renamed as (
    select
        customer_id,
        trim(customer_name) as customer_name,
        lower(trim(email)) as email,
        trim(country) as country,
        current_timestamp() as _loaded_at
    from source
)

select * from renamed
