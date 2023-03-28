{% macro render_options(options, statement) -%}
  {%- if  statement == 'alter' -%}
    {%- set key_word = 'SET' -%}
  {%- endif -%}
  {%- for k, v in options.items() -%}
    {% set value =  v['value'] %}
    {% if v['type'] == 'text' %}
      {{key_word}} {{k}} = '{{ value }}'
    {% elif v['type'] == 'identifier' %}
      {{key_word}} {{k}} = "{{ value }}"
    {% else %}
      {{key_word}} {{k}} = {{ value }}
    {%- endif -%}
  {%- endfor -%}
{%- endmacro %}
