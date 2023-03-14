{% macro get_alter_job_sql(job_identifier, options) -%}

  {%- set curr_datetime = adapter.alter_datetime() -%}

  ALTER JOB {{job_identifier}}

  {% for k, v in options.items() %}
    SET {{k}} = {{v}}
  {% endfor %}
  SET COMMENT = '{{ curr_datetime }}'

{%- endmacro %}
