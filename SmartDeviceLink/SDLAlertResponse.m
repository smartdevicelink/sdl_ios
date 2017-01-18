//  SDLAlertResponse.m
//

#import "SDLAlertResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLAlertResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlert]) {
    }
    return self;
}

- (void)setTryAgainTime:(NSNumber<SDLInt> *)tryAgainTime {
    [parameters sdl_setObject:tryAgainTime forName:SDLNameTryAgainTime];}

- (NSNumber<SDLInt> *)tryAgainTime {
    return [parameters objectForKey:SDLNameTryAgainTime];
}

@end
