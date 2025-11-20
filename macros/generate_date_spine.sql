{% macro generate_date_spine(start_date, end_date) %}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ start_date ~ "' as date)",
        end_date="cast('" ~ end_date ~ "' as date)"
    )}}
)

select
    cast(date_day as date) as date_day,
    year(date_day) as year,
    month(date_day) as month,
    day(date_day) as day,
    dayofweek(date_day) as day_of_week,
    case
        when dayofweek(date_day) in (1, 7) then true
        else false
    end as is_weekend,
    quarter(date_day) as quarter
from date_spine

{% endmacro %}
