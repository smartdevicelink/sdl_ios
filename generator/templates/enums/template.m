{% include 'copyright.txt' %}
//  {{ name }}.m

#import "{{name}}.h"
{%- block body %}
{% if add_typedef %}
typedef SDLEnum {{name}} SDL_SWIFT_ENUM;
{% endif -%}
{%- for param in params %}
{{ name }} const {{ name }}{{param.name}} = @"{{param.origin}}";
{%- endfor %}
{% endblock -%}