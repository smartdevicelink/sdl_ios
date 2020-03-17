{% include 'copyright.txt' %}
//  {{ name }}.h
{% block imports -%}
{%- for import in imports %}
#import "{{import}}.h"
{%- endfor %}
{%- endblock -%}
{%- block body %}
{% include 'description.jinja' %}
typedef SDLEnum {{ name }} SDL_SWIFT_ENUM{{ending}}{{ " __deprecated" if deprecated and deprecated is sameas true }};
{% for param in params %}
{% include 'description_param.jinja' %}
extern {{ name }} const {{ name }}{{param.name}}{{ ' %s%s%s'|format('NS_SWIFT_NAME(', param.name|lower, ')') if NS_SWIFT_NAME is defined}};
{% endfor -%}
{% endblock -%}