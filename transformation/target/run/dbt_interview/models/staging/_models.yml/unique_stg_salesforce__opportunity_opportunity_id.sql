
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "dbt"."dbt_test__audit"."unique_stg_salesforce__opportunity_opportunity_id"
    
      
    ) dbt_internal_test