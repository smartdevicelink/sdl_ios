{% include 'copyright.txt' %}
//  SDLRPCParameterNames.h

#import <Foundation/Foundation.h>
#import "SDLMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString* SDLRPCParameterName SDL_SWIFT_ENUM;
{% for param in params %}
extern SDLRPCParameterName const SDLRPCParameterName{{ param.name }};
{%- endfor %}

NS_ASSUME_NONNULL_END