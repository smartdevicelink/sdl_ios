//  SDLUnregisterAppInterfaceResponse.m
//


#import "SDLUnregisterAppInterfaceResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnregisterAppInterfaceResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnregisterAppInterface]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
