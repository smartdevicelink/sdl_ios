//  SDLSubscribeButtonResponse.m
//


#import "SDLSubscribeButtonResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSubscribeButtonResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSubscribeButton]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
