

/*
    DATA LIMITATION NOTE:
    =====================
    The true Salesforce M:M bridge between Opportunities and Products
    is the OpportunityLineItem table (opportunityid + pricebook_entry_id + quantity + unitprice).
    That table is NOT available in this dataset.

    This model simulates the relationship by joining:
        Opportunity (pricebook2id) → PricebookEntry (pricebook2id) → Product2

    This means one opportunity fans out to ALL products in its assigned pricebook,
    which overstates the opportunity-product relationship.

    In production: source OpportunityLineItem and use it as the grain here.
*/

with opportunities as (

    select
        opportunity_id,
        name            as opportunity_name,
        accountid       as account_id,
        ownerid         as owner_id,
        pricebook2id    as pricebook_id,
        stagename       as stage_name,
        closedate       as close_date,
        iswon           as is_won,
        isclosed        as is_closed,
        amount
    from "dbt"."staging"."stg_salesforce__opportunity"

),

pricebook_entries as (

    select
        pricebook_entry_id,
        pricebook2id        as pricebook_id,
        product2id          as product_id,
        unitprice           as unit_price,
        isactive            as is_active,
        usestandardprice    as use_standard_price
    from "dbt"."staging"."stg_salesforce__pricebook_entry"

),

products as (

    select
        product_id,
        name            as product_name,
        family          as product_family,
        productcode     as product_code,
        isactive        as is_active
    from "dbt"."staging"."stg_salesforce__product_2"

),

-- simulated bridge via pricebook2id
joined as (

    select
        md5(cast(coalesce(cast(o.opportunity_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(pe.pricebook_entry_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as line_item_key,
        o.opportunity_id,
        o.opportunity_name,
        o.account_id,
        o.owner_id,
        o.stage_name,
        o.close_date,
        o.is_won,
        o.is_closed,
        pe.pricebook_entry_id,
        pe.pricebook_id,
        pe.unit_price,
        pe.is_active            as pricebook_entry_is_active,
        p.product_id,
        p.product_name,
        p.product_family,
        p.product_code,
        p.is_active             as product_is_active

    from opportunities o
    left join pricebook_entries pe
        on o.pricebook_id = pe.pricebook_id
    left join products p
        on pe.product_id = p.product_id

)

select * from joined