{% extends "template.h" %}
{%- block body %}
{% include 'description.jinja' %}
typedef NS_ENUM(NSUInteger, SDL{{ name }}){{ "__deprecated" if deprecated and deprecated is sameas true }}{
{% for param in params %}
{%- macro someop() -%}{% include 'description_param.jinja' %}{%- endmacro -%}
{{ someop()|indent(4, True) }}
    SDL{{ name }}{{ param.name }} = {{ param.value }}{{ ' %s%s%s'|format('NS_SWIFT_NAME(', param.name|lower, ')') if NS_SWIFT_NAME is defined}};
{% endfor -%}
};
{% endblock -%}