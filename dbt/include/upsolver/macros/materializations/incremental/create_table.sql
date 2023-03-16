{% macro get_create_table_if_not_exists_sql(target_relation, partition_by, primary_key) -%}

{%- set old_relation = adapter.get_relation(identifier=target_relation.identifier,
                                            schema=target_relation.schema,
                                            database=target_relation.database) -%}


  {%- set curr_datetime = adapter.alter_datetime() -%}
  {%- set columns_with_types = adapter.get_columns_names_with_types(partition_by + primary_key) -%}
  {%- set columns_partitioned_by  = adapter.get_columns_names(partition_by) -%}
  {%- set columns_primary_key  = adapter.get_columns_names(primary_key) -%}

  {% if old_relation %}
    ALTER TABLE {{target_relation}}
      SET COMMENT = '{{ curr_datetime }}'
  {% else %}
    CREATE TABLE {{ target_relation }}
    ({{ columns_with_types }})
    {% if partition_by %}
      PARTITIONED BY
      {{ columns_partitioned_by }}
    {% endif %}
    {% if primary_key %}
      PRIMARY KEY
      {{ columns_primary_key }}
    {% endif %}
  {% endif %}

{%- endmacro %}
