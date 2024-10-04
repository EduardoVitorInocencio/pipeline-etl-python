-- models/datemart/dm_commodities.sql

with commodities as (
    select
        date,
        valor_fechamento
    from 
        {{ ref('stg_commodities') }}
),

movimentacao as (
    select
        data,
        acao,
        quantidade
    from 
        {{ ref('stg_movimentacao_commodities') }}
),

joined as (
    select
        c.date,
        c.valor_fechamento,
        m.acao,
        m.quantidade,
        (m.quantidade * c.valor_fechamento) as valor,
        case
            when m.acao = 'sell' then (m.quantidade * c.valor_fechamento)
            else -(m.quantidade * c.valor_fechamento)
        end as ganho
    from
        commodities c
    cross join
        movimentacao m
    where
        m.acao = 'sell'
    
),

last_day as (
    select
        max(date) as max_date
    from
        joined
),

filtered as (
    select
        *
    from
        joined
    where
        date = (select max_date from last_day)
)

select
    date,
    valor_fechamento,
    acao,
    quantidade,
    valor,
    ganho
from
    filtered