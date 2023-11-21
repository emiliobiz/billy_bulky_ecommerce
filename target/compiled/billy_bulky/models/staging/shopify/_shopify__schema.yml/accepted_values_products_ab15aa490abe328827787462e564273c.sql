
    
    

with all_values as (

    select
        category as value_field,
        count(*) as n_records

    from E_COMMERCE.marts.products
    group by category

)

select *
from all_values
where value_field not in (
    'books','electronics','home','toys','garden','clothing'
)


