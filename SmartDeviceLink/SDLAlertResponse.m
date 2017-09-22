//  SDLAlertResponse.m
//

#import "SDLAlertResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlert]) {
    }
    return self;
}

- (void)setTryAgainTime:(nullable NSNumber<SDLInt> *)tryAgainTime {
    [parameters sdl_setObject:tryAgainTime forName:SDLNameTryAgainTime];}

- (nullable NSNumber<SDLInt> *)tryAgainTime {
    return [parameters sdl_objectForName:SDLNameTryAgainTime];
}

@end

NS_ASSUME_NONNULL_END
