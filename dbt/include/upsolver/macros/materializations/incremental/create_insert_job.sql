{% macro get_create_incert_job_sql(job_identifier, table, sync, options, map_columns_by_name) -%}
  {% set enriched_options = adapter.enrich_options(options, 'upsolver_data_lake', 'transformation_options') %}

  CREATE
  {% if sync %}
    SYNC
  {% endif %}
  JOB {{job_identifier}}
  {% for k, v in enriched_options.items() %}
    {% set value =  v['value'] %}
    {% if v['type'] == 'text' %}
      {{k}} = '{{ value }}'
    {% else %}
      {{k}} = {{ value }}
    {% endif %}
  {% endfor %}
  AS INSERT INTO {{table}}
  {% if map_columns_by_name %}
    MAP_COLUMNS_BY_NAME
  {% endif %}
  {{sql}}

{%- endmacro %}
