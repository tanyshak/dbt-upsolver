{% macro get_create_copy_job_sql(job_identifier, connection_identifier, table,
                                 sync, options, source_options,
                                 source) -%}

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
