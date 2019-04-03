//  SDLAlertResponse.m
//

#import "SDLAlertResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAlert]) {
    }
    return self;
}

- (void)setTryAgainTime:(nullable NSNumber<SDLInt> *)tryAgainTime {
    [parameters sdl_setObject:tryAgainTime forName:SDLRPCParameterNameTryAgainTime];}

- (nullable NSNumber<SDLInt> *)tryAgainTime {
    return [parameters sdl_objectForName:SDLRPCParameterNameTryAgainTime ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
