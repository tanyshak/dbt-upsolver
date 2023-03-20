{% macro get_create_copy_job_sql(job_identifier, sql, table, sync, options,
                                 source_options, source) -%}
                                 
    {% set connection_identifier = adapter.get_connection_from_sql(sql) %}

    CREATE
    {% if sync %}
      SYNC
    {% endif %}
    JOB {{job_identifier}}
    {% for k, v in options.items() %}
      {{k}} = {{v}}
    {% endfor %}
    AS COPY FROM {{source}} {{connection_identifier}}
    {% for k, v in source_options.items() %}
      {{k}} = {{v}}
    {% endfor %}
    INTO {{table}}

{%- endmacro %}
