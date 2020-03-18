{% include 'copyright.txt' %}
{% block imports -%}
{%- for import in imports %}
#import "{{import}}.h"
{%- endfor %}
{%- endblock -%}
{%- block body %}
{% include 'description.jinja' %}
typedef SDLEnum {{ name }} SDL_SWIFT_ENUM{{ending}};
{% for param in params %}
{% include 'description_param.jinja' %}
extern {{ name }} const {{ name }}{{param.name}}{{ " __deprecated" if param.deprecated and param.deprecated is sameas true }};
{% endfor -%}
{% endblock -%}
