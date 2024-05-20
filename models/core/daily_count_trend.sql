{{
    config(
        materialized='incremental',
        unique_key='creation_date'
    )
}}

select
    creation_date,
    SUM(count) as daily_count
from {{ ref('agg_count_by_type') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses >= to include records whose timestamp occurred since the last run of this model)
  where creation_date > (select coalesce(max(creation_date), '1900-01-01') from {{ this }})

{% endif %}

group by 1
