{% include 'copyright.txt' %}
//  SDLRPCParameterNames.h

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN
{% for param in params %}
SDLRPCParameterName const SDLRPCParameterName{{ param.name }} = @"{{ param.origin }}";
{%- endfor %}

NS_ASSUME_NONNULL_END