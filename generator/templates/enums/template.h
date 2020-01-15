{% include 'copyright.txt' %}
//  {{ name }}.h
{% block imports -%}
{%- for import in imports %}
#import "{{import}}.h"
{%- endfor %}
{%- endblock -%}
{%- if deprecated and deprecated is sameas true -%}
{%- set ending = ' __deprecated' -%}
{%- elif deprecated and deprecated is string -%}
{%- set ending = ' __deprecated_msg("{}")'.format(deprecated) -%}
{%- endif %}
{%- block body %}
{% if description or since %}
/**
 {%- if description %}
 {%- for d in description %}
 * {{d}}
 {%- endfor %}{% endif -%}
 {%- if description and since %}
 *
 {%- endif %}
 {%- if deprecated %}
 * @deprecated
 {%- endif %}
 {%- if since %}
 * @since SDL {{since}}
 {%- endif %}
 */
{%- endif %}
typedef SDLEnum {{ name }} SDL_SWIFT_ENUM{{ending}};
{% for param in params %}
{%- if param.description or param.since %}
/**
 {%- if param.description %}
 {%- for d in param.description %}
 * {{d}}
 {%- endfor %}{% endif -%}
 {%- if param.description and param.since %}
 *
 {%- endif %}
 {%- if param.deprecated %}
 * @deprecated
 {%- endif %}
 {%- if param.since %}
 * @since SDL {{param.since}}
 {%- endif %}
 */
{%- endif %}
extern {{ name }} const {{ name }}{{param.name}}{{ ' %s%s%s'|format('NS_SWIFT_NAME(', param.name|lower, ')') if NS_SWIFT_NAME is defined}};
{% endfor -%}
{% endblock -%}