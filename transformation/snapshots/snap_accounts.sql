{% snapshot snap_accounts %}

{{
    config(
      target_schema='snapshots',
      unique_key='account_id',
      strategy='check',
      check_cols=['industry', 'rating', 'sla__c', 'active__c'],
      invalidate_hard_deletes=True
    )
}}

select
    account_id,
    name as account_name,
    industry,
    rating,
    sla__c,
    active__c,
    billingcountry as billing_country,
    numberofemployees,
    annualrevenue,
    parentid as parent_id,
    ownerid as owner_id,
    createddate as created_date,
    lastmodifieddate as last_modified_date

from {{ ref('stg_salesforce__account') }}

{% endsnapshot %}
