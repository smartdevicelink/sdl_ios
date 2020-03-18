{% extends "base_struct_function.m" %}
{% block imports %}
{{super()}}
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
{%- endblock %}
{% block constructors %}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionName{{origin}}];
    if (!self) { return nil; }

    return self;
}
#pragma clang diagnostic pop
{{super()}}
{%- endblock -%}
{% set parameters_store = 'parameters' %}
