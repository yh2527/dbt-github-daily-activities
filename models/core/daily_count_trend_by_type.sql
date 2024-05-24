{{
    config(
        materialized='incremental'
    )
}}

select
    *
from {{ ref('agg_total_count_by_type') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses >= to include records whose timestamp occurred since the last run of this model)
  where creation_date > (select coalesce(max(creation_date), '1900-01-01') from {{ this }})

{% endif %}
