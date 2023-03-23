{% macro get_create_merge_job_sql(job_identifier, table, sync, options, primary_key) -%}

  CREATE
  {% if sync %}
    SYNC
  {% endif %}
  JOB {{ job_identifier }}
  {% for k, v in options.items() %}
    {{ k }} = {{ v }}
  {% endfor %}
  AS MERGE INTO {{ table }} AS target
  USING (
  {{ sql }}
  )
  {% if primary_key %}
    source ON (
      {% for item in primary_key %}
        target.{{ item['field'] }} = source.{{ item['field'] }}
      {% endfor %}
    )
  {% endif %}
  WHEN MATCHED THEN REPLACE
  WHEN NOT MATCHED THEN INSERT MAP_COLUMNS_BY_NAME

{%- endmacro %}
