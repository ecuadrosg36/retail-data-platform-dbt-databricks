{% macro generate_surrogate_key(fields) -%}
    md5(concat({{ fields | join(",'|',") }}))
{%- endmacro %}
