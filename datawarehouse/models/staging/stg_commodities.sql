-- import

with source as (
    select
        "Date",
        "Close"
    from {{source ('exemplo_clqk', 'commodities')}}
),


--renamed

renamed as (

    select
        cast("Date" as date) as date,
        "Close" as valor_fechamento
    from
        source
)

--select * from
select * from renamed