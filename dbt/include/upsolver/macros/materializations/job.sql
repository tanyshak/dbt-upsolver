{% materialization job, adapter='upsolver' %}
  {%- set identifier = model['alias'] -%}

  {% set sync = config.get('sync', '') %}
  {% set job_options = config.get('job_options', {}) %}
  {%- set curr_datetime = adapter.alter_datetime() -%}

  {%- set old_relation = adapter.get_relation(identifier=identifier,
                                              schema=schema,
                                              database=database) -%}
  {%- set target_relation = api.Relation.create(identifier=identifier,
                                                schema=schema,
                                                database=database,
                                                type="job") -%}

  {{ run_hooks(pre_hooks, inside_transaction=False) }}
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {% if old_relation %}
    {% call statement('main') -%}

      ALTER JOB {{target_relation.identifier}}
        SET COMMENT = '{{ curr_datetime }}';

    {%- endcall %}
  {% else %}
    {% call statement('main') -%}

      CREATE {{ sync }} JOB {{target_relation.identifier}}
      {% for k, v in job_options.items() %}
        {{k}} = {{v}}
      {% endfor %}
      AS
      {{ sql }}

    {%- endcall %}
  {% endif %}

  {% do persist_docs(target_relation, model) %}

  {{ run_hooks(post_hooks, inside_transaction=False) }}
  {{ run_hooks(post_hooks, inside_transaction=True) }}

  {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
