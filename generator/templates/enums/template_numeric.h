{% extends "template.h" %}
{%- block body %}
{% include 'description.jinja' %}
typedef NS_ENUM(NSUInteger, SDL{{ name }}){
{% for param in params %}
{%- macro someop() -%}{% include 'description_param.jinja' %}{%- endmacro -%}
{{ someop()|indent(4, True) }}
    SDL{{ name }}{{ param.name }} = {{ param.value }}{{ " __deprecated" if param.deprecated and param.deprecated is sameas true }};
{% endfor -%}
};
{% endblock -%}