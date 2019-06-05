//  SDLScrollableMessageResponse.m
//


#import "SDLScrollableMessageResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

@implementation SDLScrollableMessageResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameScrollableMessage]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end
