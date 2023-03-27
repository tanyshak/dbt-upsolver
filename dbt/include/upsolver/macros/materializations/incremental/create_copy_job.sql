{% macro get_create_copy_job_sql(job_identifier, sql, table, sync, options, source) -%}

    {% set connection_identifier = adapter.get_connection_from_sql(sql) %}
    {{ log("Options: " ~ options ) }}
    {% set job_options, source_options = adapter.separate_options(options, source) %}

    CREATE
    {% if sync %}
      SYNC
    {% endif %}
    JOB {{job_identifier}}
    {% for k, v in job_options.items() %}
      {% set value =  v['value'] %}
      {% if v['type'] == 'text' %}
        {{k}} = '{{ value }}'
      {% else %}
        {{k}} = {{ value }}
      {% endif %}
    {% endfor %}
    AS COPY FROM {{source}} {{connection_identifier}}
    {% for k, v in source_options.items() %}
      {% set value =  v['value'] %}
      {% if v['type'] == 'text' %}
        {{k}} = '{{ value }}'
      {% else %}
        {{k}} = {{ value }}
      {% endif %}
    {% endfor %}
    INTO {{table}}

{%- endmacro %}
