{% macro get_create_incert_job_sql(job_identifier,
                                  table, sync, options,
                                  map_columns_by_name) -%}

  CREATE
  {% if sync %}
    SYNC
  {% endif %}
  JOB {{job_identifier}}
  {% for k, v in options.items() %}
    {{k}} = {{v}}
  {% endfor %}
  AS INSERT INTO {{table}}
  {% if map_columns_by_name %}
    MAP_COLUMNS_BY_NAME
  {% endif %}
  {{sql}}

{%- endmacro %}
