{#- This template creates RPC struct .m files -#}
{% extends "base_struct_function.m" %}
{% block imports %}
{{super()}}
#import "SDLRPCParameterNames.h"
{%- endblock %}
{% set parameters_store = 'store' %}