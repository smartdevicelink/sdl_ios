{#- Numeric based enum. If the enum element values are numeric the enum should be a numerical.
    This template extends base "templates/enums/template.h" and overriding block body -#}
{% extends "template.h" %}
{%- block body %}
{% include 'description.jinja' %}
typedef NS_ENUM(NSUInteger, {{ name }}){
{% for param in params %}
{%- macro description_param() -%}{% include 'description_param.jinja' %}{%- endmacro -%}
{{ description_param()|indent(4, True) }}
    {{ name }}{{ param.name }} = {{ param.value }}{{ " __deprecated" if param.deprecated }}{{',' if not loop.last }}
{% endfor -%}
};
{% endblock -%}