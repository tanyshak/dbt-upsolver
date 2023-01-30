
{% materialization connection, adapter='upsolver' %}
  {%- set identifier = model['alias'] -%}

  {% set connection_type = config.require('connection_type') %}
  {% set aws_role = config.get('aws_role') %}
  {% set external_id = config.get('external_id') %}
  {% set read_only = config.get('read_only') %}

  {%- set old_relation = adapter.get_relation(identifier=identifier,
                                              schema=schema,
                                              database=database) -%}
  {%- set target_relation = api.Relation.create(identifier=identifier,
                                                schema=schema,
                                                database=database,
                                                type="connection") -%}

  {% if old_relation %}
    {{ adapter.drop_relation(old_relation) }}
  {% endif %}

  {{ run_hooks(pre_hooks, inside_transaction=False) }}
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {% call statement('main') -%}

    CREATE {{ connection_type }} CONNECTION {{target_relation.identifier}}
    {% if aws_role %}
      AWS_ROLE = {{"'"}}{{aws_role}}{{"'"}}
    {% endif %}
    {% if external_id %}
      EXTERNAL_ID = {{"'"}}{{external_id}}{{"'"}}
    {% endif %}
    {% if read_only %}
      READ_ONLY = {{read_only}}
    {% endif %}

  {%- endcall %}

  {% do persist_docs(target_relation, model) %}

  {{ run_hooks(post_hooks, inside_transaction=False) }}
  {{ run_hooks(post_hooks, inside_transaction=True) }}

  {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
