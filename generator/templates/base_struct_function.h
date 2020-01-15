{% include 'copyright.txt' %}
//  {{name}}.h
{% block imports %}
{%- for import in imports.enum %}
#import "{{import}}.h"
{%- endfor %}
{%- if imports.struct %}
{% endif -%}
{%- for import in imports.struct %}
@class {{import}};
{%- endfor %}
{%- endblock %}
{%- if deprecated and deprecated is sameas true -%}
{%- set ending = ' __deprecated' -%}
{%- elif deprecated and deprecated is string -%}
{%- set ending = ' __deprecated_msg("{}")'.format(deprecated) -%}
{%- endif %}

NS_ASSUME_NONNULL_BEGIN
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
@interface {{name}} : {{extends_class}}{{ending}}
{%- block constructors %}
{% for c in constructors %}
/**
 {%- if c.description %}
 {%- for d in c.description %}
 * {{d}}
 {%- endfor %}
 *
 {%- endif %}
 {%- for a in c.all %}
 * @param {{a.variable}} - {{a.constructor_argument}}
 {%- endfor %}
 * @return A {{name}} object
 */
{%- if c.deprecated %}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
{%- endif %}
- (instancetype)initWith{{c.init}};
{%- if c.deprecated %}
#pragma clang diagnostic pop
{%- endif %}
{% endfor -%}
{%- endblock -%}
{%- block methods %}
{%- for param in params %}
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
 {%- if param.description or param.since %}
 *
 {%- endif %}
 * {{'Required, ' if param.mandatory else 'Optional, '}}{{param.type_native}}
 */
{%- if param.deprecated and param.deprecated is sameas true -%}
{%- set ending = ' __deprecated' -%}
{%- elif param.deprecated and param.deprecated is string -%}
{%- set ending = ' __deprecated_msg("{}")'.format(param.deprecated) -%}
{%- endif %}
@property ({{'nullable, ' if not param.mandatory}}{{param.modifier}}, nonatomic) {{param.type_sdl}}{{param.origin}}{{ending}};
{% endfor -%}
{%- endblock %}
@end

NS_ASSUME_NONNULL_END
