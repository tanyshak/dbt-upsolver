/* For examples of how to fill out the macros please refer to the postgres adapter and docs
postgres adapter macros: https://github.com/dbt-labs/dbt-core/blob/main/plugins/postgres/dbt/include/postgres/macros/adapters.sql
dbt docs: https://docs.getdbt.com/docs/contributing/building-a-new-adapter
*/

{% macro upsolver__alter_column_type(relation,column_name,new_column_type) -%}
'''Changes column name or data type'''
/*
    1. Create a new column (w/ temp name and correct type)
    2. Copy data over to it
    3. Drop the existing column (cascade!)
    4. Rename the new column to existing column
*/
{% endmacro %}

{macro upsolver__check_schema_exists(information_schema,schema) -%}
'''Checks if schema name exists and returns number or times it shows up.'''
  {{ print('Checks if schema name exists') }}
{% endmacro %}


--  Example from postgres adapter in dbt-core
--  Notice how you can build out other methods than the designated ones for the impl.py file,
--  to make a more robust adapter. ex. (verify_database)

/*

 {% macro postgres__create_schema(relation) -%}
   {% if relation.database -%}
    {{ adapter.verify_database(relation.database) }}
  {%- endif -%}   {%- call statement('create_schema') -%}
     create schema if not exists {{ relation.without_identifier().include(database=False) }}
   {%- endcall -%}
 {% endmacro %}

*/


/*

{% macro postgres__drop_schema(relation) -%}
  {% if relation.database -%}
    {{ adapter.verify_database(relation.database) }}
  {%- endif -%}
  {%- call statement('drop_schema') -%}
    drop schema if exists {{ relation.without_identifier().include(database=False) }} cascade
  {%- endcall -%}
{% endmacro %}

*/

{% macro upsolver__drop_relation(relation) -%}
'''Deletes relatonship identifer between tables.'''
  {% call statement('drop_relation') -%}
    drop materialized view {{ relation }}
  {%- endcall %}
{% endmacro %}

{% macro upsolver__drop_schema(relation) -%}
'''drops a schema in a target database.'''
/*
  1. If database exists
  2. search all calls of schema, and change include value to False, cascade it to backtrack
*/
{% endmacro %}

/*

 Example of 1 of 3 required macros that does not have a default implementation
{% macro postgres__get_columns_in_relation(relation) -%}
  {% call statement('get_columns_in_relation', fetch_result=True) %}
      select
          column_name,
          data_type,
          character_maximum_length,
          numeric_precision,
          numeric_scale
      from {{ relation.information_schema('columns') }}
      where table_name = '{{ relation.identifier }}'
        {% if relation.schema %}
        and table_schema = '{{ relation.schema }}'
        {% endif %}
      order by ordinal_position
  {% endcall %}
  {% set table = load_result('get_columns_in_relation').table %}
  {{ return(sql_convert_columns_in_relation(table)) }}
{% endmacro %}
*/


{% macro upsolver__get_columns_in_relation(relation) -%}
'''Returns a list of Columns in a table.'''
/*
  1. select as many values from column as needed
  2. search relations to columns
  3. where table name is equal to the relation identifier
  4. if a relation schema exists and table schema is equal to the relation schema
  5. order in whatever way you want to call.
  6. create a table by loading result from call
  7. return new table
*/
{% endmacro %}

--  Example of 2 of 3 required macros that do not come with a default implementation

/*

{% macro postgres__list_relations_without_caching(schema_relation) %}
  {% call statement('list_relations_without_caching', fetch_result=True) -%}
    select
      '{{ schema_relation.database }}' as database,
      tablename as name,
      schemaname as schema,
      'table' as type
    from pg_tables
    where schemaname ilike '{{ schema_relation.schema }}'
    union all
    select
      '{{ schema_relation.database }}' as database,
      viewname as name,
      schemaname as schema,
      'view' as type
    from pg_views
    where schemaname ilike '{{ schema_relation.schema }}'
  {% endcall %}
  {{ return(load_result('list_relations_without_caching').table) }}
{% endmacro %}

*/
{% macro list_relation_without_caching(schema_relation, relation_type) -%}
  {% set source = relation_type +'s' %}
  {% call statement('list_relation_without_caching', fetch_result=True) -%}
    select
      '{{ schema_relation.database }}' as database,
      name,
      '{{ schema_relation.schema }}' as schema,
      '{{ relation_type }}' as type
    from information_schema."{{ source }}"
      {% if relation_type in ['table', 'view'] %}
        where schema = '{{ schema_relation.schema }}'
      {% endif %}
  {% endcall %}
  {{ return(load_result('list_relation_without_caching').table) }}
{% endmacro %}

{% macro upsolver__list_schemas(database) -%}
'''Returns a table of unique schemas.'''
/*
  1. search schemea by specific name
  2. create a table with names
*/
{% endmacro %}

{% macro upsolver__rename_relation(from_relation, to_relation) -%}
'''Renames a relation in the database.'''
/*
  1. Search for a specific relation name
  2. alter table by targeting specific name and passing in new name
*/
{% endmacro %}

{% macro upsolver__truncate_relation(relation) -%}
'''Removes all rows from a targeted set of tables.'''
/*
  1. grab all tables tied to the relation
  2. remove rows from relations
*/
{% endmacro %}

/*

Example 3 of 3 of required macros that does not have a default implementation.
 ** Good example of building out small methods ** please refer to impl.py for implementation of now() in postgres plugin
{% macro postgres__current_timestamp() -%}
  now()
{%- endmacro %}

*/

{% macro upsolver__current_timestamp() -%}
'''Returns current UTC time'''
{# docs show not to be implemented currently. #}
{% endmacro %}

{% macro upsolver__create_arbitrary_object(sql) -%}
    {{ sql }}
{%- endmacro %}
