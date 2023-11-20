
    
    

select
    sale_date as unique_field,
    count(*) as n_records

from E_COMMERCE.intermediate.int_sales_trends
where sale_date is not null
group by sale_date
having count(*) > 1


