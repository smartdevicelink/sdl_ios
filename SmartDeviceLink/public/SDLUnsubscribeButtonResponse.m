//  SDLUnsubscribeButtonResponse.m
//


#import "SDLUnsubscribeButtonResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeButtonResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnsubscribeButton]) {
    }
    return self;
}
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
