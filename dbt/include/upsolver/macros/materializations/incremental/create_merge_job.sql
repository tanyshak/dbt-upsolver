{% macro get_create_merge_job_sql(job_identifier, sync, options) -%}

  CREATE
  {% if sync %}
    SYNC
  {% endif %}
  JOB {{job_identifier}}
  {% for k, v in options.items() %}
    {{k}} = {{v}}
  {% endfor %}
  AS MERGE INTO {{table}} AS target
  {{sql}}


{%- endmacro %}
