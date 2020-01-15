{% include 'copyright.txt' %}
//  SDLRPCFunctionNames.m

#import "SDLRPCFunctionNames.h"
{% for param in params %}
SDLRPCFunctionName const SDLRPCFunctionName{{ param.name }} = @"{{ param.origin }}";
{%- endfor %}
