{% macro get_create_merge_job_sql(job_identifier, table, sync, options, primary_key) -%}

  {% set enriched_options = adapter.enrich_options(options, 'upsolver_data_lake', 'transformation_options') %}

  CREATE
  {% if sync %}
    SYNC
  {% endif %}
  JOB {{ job_identifier }}
  {% for k, v in enriched_options.items() %}
    {% set value =  v['value'] %}
    {% if v['type'] == 'text' %}
      {{k}} = '{{ value }}'
    {% elif v['type'] == 'identifier' %}
      {{k}} = "{{ value }}"
    {% else %}
      {{k}} = {{ value }}
    {% endif %}
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
