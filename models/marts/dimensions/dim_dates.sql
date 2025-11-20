{{
    config(
        materialized='table',
        tags=['marts', 'dimension', 'dates']
    )
}}

{{ generate_date_spine(start_date='2020-01-01', end_date='2025-12-31') }}
