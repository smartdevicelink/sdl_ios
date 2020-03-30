{#- To avoid code duplication was crated this parent file, which contain common part used in:
    "templates/functions/template.m" and "templates/structs/template.m". -#}
{% include 'copyright.txt' %}
{%- block imports %}
#import "{{name}}.h"
#import "NSMutableDictionary+Store.h"
{%- for import in imports %}
#import "{{import}}.h"
{%- endfor %}
{%- endblock %}

NS_ASSUME_NONNULL_BEGIN
{% if deprecated %}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
{%- endif %}
@implementation {{name}}
{%- if deprecated %}
#pragma clang diagnostic pop
{%- endif %}
{% block constructors %}
{%- for c in constructors %}
{%- if deprecated or c.deprecated %}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
{%- endif %}
- (instancetype)initWith{{c.init}} {
{%- if deprecated or c.deprecated %}
#pragma clang diagnostic pop
{%- endif %}
    self = [{{ 'self' if c.self else 'super' }} init{{ 'With' + c.self if c.self and c.self is string }}];
    if (!self) {
        return nil;
    }
    {%- for a in c.arguments %}
    self.{{a.origin}} = {{a.constructor_argument}};
    {%- endfor %}
    return self;
}
{% endfor -%}
{% endblock -%}
{%- block methods %}
{%- for p in params %}
{%- if deprecated or p.deprecated %}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
{%- endif %}
- (void)set{{p.origin|title}}:({{'nullable ' if not p.mandatory}}{{p.type_generic}}{{p.type_sdl|trim}}){{p.origin}} {
{%- if deprecated or p.deprecated %}
#pragma clang diagnostic pop
{%- endif %}
    [self.{{parameters_store}} sdl_setObject:{{p.origin}} forName:SDLRPCParameterName{{p.method_suffix}}];
}
{% if deprecated or p.deprecated %}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
{%- endif %}
- ({{'nullable ' if not p.mandatory}}{{p.type_generic}}{{p.type_sdl|trim}}){{p.origin}} {
{%- if deprecated or p.deprecated %}
#pragma clang diagnostic pop
{%- endif %}
    {% if p.mandatory -%}
    NSError *error = nil;
    {% endif -%}
    return [self.{{parameters_store}} sdl_{{p.for_name}}ForName:SDLRPCParameterName{{p.method_suffix}}{{' ofClass:'+p.of_class if p.of_class}} error:{{'&error' if p.mandatory else 'nil'}}];
}
{% endfor %}
{%- endblock %}
@end

NS_ASSUME_NONNULL_END
