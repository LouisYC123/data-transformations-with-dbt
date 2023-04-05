# data-transformations-with-dbt
A gentle introduction to using dbt for the T in ELT


### Note: 
Postgres 13 is the highest version you can use here due to an issue with dbt and SCRAM in dockerised postgres on mac1. Until a fix is deployed, please stick with Postgres 13 as defined in the dockerfile




### dbt commands: 
dbt --profiles-dir profiles docs generate
dbt --profiles-dir profiles docs serve


### Tests
customer_id - unique, not null