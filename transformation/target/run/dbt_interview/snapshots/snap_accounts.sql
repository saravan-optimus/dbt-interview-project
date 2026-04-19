
      update "dbt"."snapshots"."snap_accounts" as DBT_INTERNAL_TARGET
    set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to
    from "snap_accounts__dbt_tmp20260419071750518687" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_scd_id::text = DBT_INTERNAL_TARGET.dbt_scd_id::text
      and DBT_INTERNAL_SOURCE.dbt_change_type::text in ('update'::text, 'delete'::text)
      
        and DBT_INTERNAL_TARGET.dbt_valid_to is null;
      

    insert into "dbt"."snapshots"."snap_accounts" ("account_id", "account_name", "industry", "rating", "sla__c", "active__c", "billing_country", "numberofemployees", "annualrevenue", "parent_id", "owner_id", "created_date", "last_modified_date", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to", "dbt_scd_id")
    select DBT_INTERNAL_SOURCE."account_id",DBT_INTERNAL_SOURCE."account_name",DBT_INTERNAL_SOURCE."industry",DBT_INTERNAL_SOURCE."rating",DBT_INTERNAL_SOURCE."sla__c",DBT_INTERNAL_SOURCE."active__c",DBT_INTERNAL_SOURCE."billing_country",DBT_INTERNAL_SOURCE."numberofemployees",DBT_INTERNAL_SOURCE."annualrevenue",DBT_INTERNAL_SOURCE."parent_id",DBT_INTERNAL_SOURCE."owner_id",DBT_INTERNAL_SOURCE."created_date",DBT_INTERNAL_SOURCE."last_modified_date",DBT_INTERNAL_SOURCE."dbt_updated_at",DBT_INTERNAL_SOURCE."dbt_valid_from",DBT_INTERNAL_SOURCE."dbt_valid_to",DBT_INTERNAL_SOURCE."dbt_scd_id"
    from "snap_accounts__dbt_tmp20260419071750518687" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_change_type::text = 'insert'::text;


  