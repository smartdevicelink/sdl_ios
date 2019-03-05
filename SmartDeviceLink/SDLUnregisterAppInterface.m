//  SDLUnregisterAppInterface.m
//


#import "SDLUnregisterAppInterface.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnregisterAppInterface

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnregisterAppInterface]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
