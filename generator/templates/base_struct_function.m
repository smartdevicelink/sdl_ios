{% include 'copyright.txt' %}
{%- block imports %}
#import "{{name}}.h"
#import "NSMutableDictionary+Store.h"
{%- for import in imports %}
#import "{{import}}.h"
{%- endfor %}
{%- endblock %}

NS_ASSUME_NONNULL_BEGIN

@implementation {{name}}
{% block constructors %}
{%- for c in constructors %}
- (instancetype)initWith{{c.init}} {
{%- if c.deprecated %}
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
{%- endif %}
    self = [{{'self' if c.self else 'super'}} init{{'With'+c.self if c.self}}];
{%- if c.deprecated %}
    #pragma clang diagnostic pop
{%- endif %}
    if (!self) {
        return nil;
    }
    {%- for a in c.arguments %}
    {%- if a.deprecated %}
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    {%- endif %}
    self.{{a.origin}} = {{a.constructor_argument}};
    {%- if a.deprecated %}
    #pragma clang diagnostic pop
    {%- endif %}
    {%- endfor %}
    return self;
}
{% endfor -%}
{% endblock -%}
{%- block methods %}
{%- for p in params %}
{%- if p.deprecated %}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
{%- endif %}
- (void)set{{p.origin|title}}:({{'nullable ' if not p.mandatory}}{{p.type_generic}}{{p.type_sdl|trim}}){{p.origin}} {
    [self.{{parameters_store}} sdl_setObject:{{p.origin}} forName:SDLRPCParameterName{{p.method_suffix}}];
}

- ({{'nullable ' if not p.mandatory}}{{p.type_generic}}{{p.type_sdl|trim}}){{p.origin}} {
    {% if p.mandatory -%}
    NSError *error = nil;
    {% endif -%}
    return [self.{{parameters_store}} sdl_{{p.for_name}}ForName:SDLRPCParameterName{{p.method_suffix}}{{' ofClass:'+p.of_class if p.of_class}} error:{{'&error' if p.mandatory else 'nil'}}];
}
{%- if p.deprecated %}
#pragma clang diagnostic pop
{%- endif %}
{% endfor %}
{%- endblock %}
@end

NS_ASSUME_NONNULL_END
