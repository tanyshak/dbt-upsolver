{% materialization connection, adapter='upsolver' %}
  {%- set identifier = model['alias'] -%}
  {% set connection_type = config.require('connection_type') %}
  {% set connection_options = config.require('connection_options') %}
  {%- set curr_datetime = adapter.alter_datetime() -%}

  {%- set old_relation = adapter.get_relation(identifier=identifier,
                                              schema=schema,
                                              database=database) -%}
  {%- set target_relation = api.Relation.create(identifier=identifier,
                                                schema=schema,
                                                database=database,
                                                type="connection") -%}


  {{ run_hooks(pre_hooks, inside_transaction=False) }}
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {% if old_relation %}
    {% call statement('main') -%}
      ALTER {{ connection_type }} CONNECTION {{target_relation.identifier}}
        {% for k, v in connection_options.items() %}
          SET {{k}} = {{v}}
        {% endfor %}
    {%- endcall %}
  {% else %}
    {% call statement('main') -%}
      CREATE {{ connection_type }} CONNECTION {{target_relation.identifier}}
      {% for k, v in connection_options.items() %}
        {{k}} = {{v}}
      {% endfor %}
    {%- endcall %}
  {% endif %}

  {% do persist_docs(target_relation, model) %}

  {{ run_hooks(post_hooks, inside_transaction=False) }}
  {{ run_hooks(post_hooks, inside_transaction=True) }}

  {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
