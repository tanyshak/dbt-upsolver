{% materialization materializedview, adapter='upsolver' %}
  {%- set identifier = model['alias'] -%}

  {% if config.get('sync', none) %}
    {% set sync = SYNC %}
  {% else %}
    {% set sync = '' %}
  {% endif %}

  {%- set old_relation = adapter.get_relation(identifier=identifier,
                                              schema=schema,
                                              database=database) -%}
  {%- set target_relation = api.Relation.create(identifier=identifier,
                                                schema=schema,
                                                database=database,
                                                type="materializedview") -%}

  {% if old_relation %}
    {{ adapter.drop_relation(old_relation) }}
  {% endif %}

  {{ run_hooks(pre_hooks, inside_transaction=False) }}
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  {% call statement('main') -%}

    CREATE {{ sync }} MATERIALIZED VIEW  {{target_relation.database}}.{{target_relation.schema}}.{{target_relation.identifier}} AS
      {{ sql }}

  {%- endcall %}

  {% do persist_docs(target_relation, model) %}

  {{ run_hooks(post_hooks, inside_transaction=False) }}
  {{ run_hooks(post_hooks, inside_transaction=True) }}

  {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
