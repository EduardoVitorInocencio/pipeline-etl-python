-- models/staging/stg_movimentacao_commodities.sql

with source as (
    select
        date,
        action,
        quantity
    from 
        {{ source('exemplo_clqk', 'movimentacao_commodities') }}
),

renamed as (
    select
        cast(date as date) as data,
        action as acao,
        quantity as quantidade
    from source
)

select
    data,
    acao,
    quantidade
from renamed