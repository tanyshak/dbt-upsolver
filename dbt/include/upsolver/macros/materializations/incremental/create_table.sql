{% macro get_create_table_if_not_exists_sql(target_relation, schema, database) -%}

{%- set old_relation = adapter.get_relation(identifier=target_relation.identifier,
                                            schema=target_relation.schema,
                                            database=target_relation.database) -%}

  {%- set curr_datetime = adapter.alter_datetime() -%}

  {% if old_relation %}
    ALTER TABLE {{target_relation}}
      SET COMMENT = '{{ curr_datetime }}'
  {% else %}
    CREATE TABLE {{ target_relation }}
    PARTITIONED BY $event_date
  {% endif %}

{%- endmacro %}
