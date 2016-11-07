//  SDLAlertResponse.m
//

#import "SDLAlertResponse.h"

#import "SDLNames.h"

@implementation SDLAlertResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameAlert]) {
    }
    return self;
}

- (void)setTryAgainTime:(NSNumber<SDLInt> *)tryAgainTime {
    [self setObject:tryAgainTime forName:SDLNameTryAgainTime];}

- (NSNumber<SDLInt> *)tryAgainTime {
    return [parameters objectForKey:SDLNameTryAgainTime];
}

@end
