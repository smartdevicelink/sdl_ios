//  SDLAlertResponse.m
//

#import "SDLAlertResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAlert]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setTryAgainTime:(nullable NSNumber<SDLInt> *)tryAgainTime {
    [self.parameters sdl_setObject:tryAgainTime forName:SDLRPCParameterNameTryAgainTime];}

- (nullable NSNumber<SDLInt> *)tryAgainTime {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTryAgainTime ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
