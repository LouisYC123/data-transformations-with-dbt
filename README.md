# data-transformations-with-dbt
A gentle introduction to using dbt for the T in ELT

## Summary
This repo serves as an introduction to using dbt for data transformations. Data for a fictional commerce company is loaded to a dockerized postgres instance, and dbt is then used to deploy source, staging and data mart models. A high-level guide to the dbt workflow used in this project can be found in the below 'Using dbt' section of this README.  

This example project follows the ELT paradigm, where data is extracted and loaded into a data warehouse, followed by data transformations conducted within the data warehouse. dbt is an excellent tool for the Transformations step in an ELT workflow as it brings many of the principles of software engineering (version control, testing, procedural programming etc) into the world of SQL data modelling.

**Note:** This project is not intended to represent a perfect data modelling workflow, nor present data fit for interesting analysis. Instead, this repo is intended to be a simple guide to get up and running with the basics of dbt quickly.

## Prerequisites

 - Docker  

## Setup

1. Clone this repo, and create a .env file in the root of the folder with:  

```
POSTGRES_USER=<username_of_your_choice>
POSTGRES_PASSWORD=<password_of_your_choice>
PGADMIN_DEFAULT_EMAIL=<email_of_your_choice> # you can use anything here. e.g - admin@admin.com
PGADMIN_DEFAULT_PASSWORD=<password_of_your_choice>
PGADMIN_LISTEN_PORT=5050  
```   


2. Open up a terminal and run:

``` docker compose build && docker compose up ```

This will build images and spin up four containers

- pg_db: postgres docker container
- pgadmin: browser-based SQL IDE on localhost:5050 (usage is optional)
- python_extractload: python container to extract raw data from zip file and load to postgres db
- dbt: python container to host dbt

**Note:** This may take several minutes the first time you build the images.  

The python_extractload service will wait for the pg_db to be up and healthy, before extracting the data from the zipped file in extract_load/data/ and loading it to the postgres ```raw_data``` database.

3. Once dbt run has completed (you will get an message from the dbt container stating  ```Done``` ), you can work inside the dbt container ('attach container' if using VS Code)  

**Note:** Postgres 13 is the highest version you can use here due to an issue with dbt and SCRAM in dockerised postgres on mac1. Until a fix is available, please stick with Postgres 13 as defined in the dockerfile  



### Useful dbt commands: 
run dbt:  
dbt --profiles-dir profiles run  

generate documentation:  
dbt --profiles-dir profiles docs generate  

view documentation via browser:  
dbt --profiles-dir profiles docs serve  


## Using dbt

Models are the core feature of dbt. Models are simply SQL select statements. They promote modularity in a data modelling project and are used by dbt in a DAG-like manner. You are free to structure your project as you please, but a best practice dbt project would follow a structure along the lines of:  

src_models (source data) --> stg_models (staging tables) --> intermediate_models (optional / as required) --> mart_models (data marts ready for consumption)  


1. **Set up sources and src models**  
  - Use a sources/source.yml to define your source data  
  - Create src_.sql models in models/sources/. These can include light transformations such as column renaming or data type conversions  
2. **Set up stg models for transformations**  
  - Create stg_.sql models in models/staging/ . These can be used to perform initial / layer 1 transformations to start getting your data into the shape you need.  
  - Use CTEs and jinja templates to reference your sources (see models in models/staging/ ).  
  - You can make use of the dbt utility package ```dbt_utils``` to help set up custom unique identifiers that can be used as Primary Keys if needed.  
  - To make use of packages, you need a yml file named packages.yml that lists the packages you want installed. Vist ```https://hub.getdbt.com``` to see available packages.  
  - Jinja is your friend. One of the most powerful features of dbt is its leveraging of jinja templating to enhance what you can do with SQL. This repo will only scratch the  surface of Jinja templating (see both stg_ models for examples).  
3. **Set up intermediate models (as many as needed)**  
  - These can be used to perform any layer 2 transformations that might be needed.  
4. **Set up data marts**  
  - These represent the final models and convey the data that is required by the end user for their analysis / BI Tools.   
5. **Create a schema.yml to add documentation and generic tests to your models (More on this below).**  
6. **Define the type of materialization (view, table etc) you want your models deployed as in your project yaml (see dbt_project.yml)**  
7. **Set up testing for source data**  
  - Once you have a good idea of how you want your staging and mart models to behave, you should ensure consistency and data quality by using tests. Tests will ensure that all future data entering the data warehouse conforms to business logic and expectations. This helps prevent data quality issues creeping into your data marts and ensures confidence in the data used for downstream analysis.
  - You can define dbt generic test (null value checks, uniqueness, accepted values etc) in the schema.yml.
  - You can defince custom singular tests by creating sql scripts in the ```tests``` folder. A generic test should return an empty result set to pass. If any records are returned by the generic test query, they are considered failing records.  
8. **Create Documentation.**  
 - Documentation is added by adding  ```description:``` lines to your tables and columns in schema.yml.  
 - Documentation is a vital part of any data project. You should take the approach that no project is finished until it has documentation. This is as much for your own benefit as it is for your colleagues. Revisiting code you wrote 6 months ago that has no documentation is a pain in the a**.
 - You can add tabular documentation by creating markdown files and reference them in your documentation. (See models/staging/ship_mode_desc.md and schema.yml) 

