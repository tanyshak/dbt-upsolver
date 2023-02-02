{% materialization job, adapter='upsolver' %}
  {%- set identifier = model['alias'] -%}

  {% set sync = config.get('sync', '') %}

  {% set config = config.get_all_except('sync') %}

  {%- set old_relation = adapter.get_relation(identifier=identifier,
                                              schema=schema,
                                              database=database) -%}
  {%- set target_relation = api.Relation.create(identifier=identifier,
                                                schema=schema,
                                                database=database,
                                                type="job") -%}

  {% if old_relation %}
    {{ adapter.drop_relation(old_relation) }}
  {% endif %}

  {{ run_hooks(pre_hooks, inside_transaction=False) }}
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {% call statement('main') -%}
    CREATE {{ sync }} JOB {{target_relation.identifier}}

    {% for k, v in config.items() %}
      {{k}} = {{v}}
    {% endfor %}
    AS

      {{ sql }}

  {%- endcall %}

  {% do persist_docs(target_relation, model) %}

  {{ run_hooks(post_hooks, inside_transaction=False) }}
  {{ run_hooks(post_hooks, inside_transaction=True) }}

  {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
