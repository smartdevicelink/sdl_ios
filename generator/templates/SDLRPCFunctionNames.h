{% include 'copyright.txt' %}
//  SDLRPCFunctionNames.h

#import "SDLEnum.h"

/**
 *  All RPC request / response / notification names
 */
typedef SDLEnum SDLRPCFunctionName SDL_SWIFT_ENUM;
{% for param in params %}
{#- description if exist in source xml, will be putted here
    since if exist in source xml, will be putted here -#}
{%- if param.description or param.since %}
/**
 {%- if param.description %}
 {%- for d in param.description %}
 * {{d}}
 {%- endfor %}{% endif -%}
 {%- if param.description and param.since %}
 *
 {%- endif %}
 {%- if param.since %}
 * @since SDL {{param.since}}
 {%- endif %}
 */
{%- endif %}
extern SDLRPCFunctionName const SDLRPCFunctionName{{ param.name }};
{% endfor -%}
