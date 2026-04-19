
        
            delete from "dbt"."marts"."fct_opportunities"
            where (
                opportunity_id) in (
                select (opportunity_id)
                from "fct_opportunities__dbt_tmp20260419071757727464"
            );

        
    

    insert into "dbt"."marts"."fct_opportunities" ("opportunity_key", "opportunity_id", "account_id", "owner_id", "campaign_id", "contact_id", "opportunity_name", "opportunity_type", "stage_name", "amount", "probability", "expected_revenue", "close_date", "is_closed", "is_won", "lead_source", "forecast_category", "forecast_category_name", "fiscal_year", "fiscal_quarter", "opportunity_status", "deal_size_band", "probability_band", "days_to_close", "opportunity_age_days", "account_name", "account_industry", "account_country", "owner_full_name", "owner_department", "campaign_name", "campaign_type", "created_date", "last_modified_date", "last_stage_change_date", "is_deleted")
    (
        select "opportunity_key", "opportunity_id", "account_id", "owner_id", "campaign_id", "contact_id", "opportunity_name", "opportunity_type", "stage_name", "amount", "probability", "expected_revenue", "close_date", "is_closed", "is_won", "lead_source", "forecast_category", "forecast_category_name", "fiscal_year", "fiscal_quarter", "opportunity_status", "deal_size_band", "probability_band", "days_to_close", "opportunity_age_days", "account_name", "account_industry", "account_country", "owner_full_name", "owner_department", "campaign_name", "campaign_type", "created_date", "last_modified_date", "last_stage_change_date", "is_deleted"
        from "fct_opportunities__dbt_tmp20260419071757727464"
    )
  