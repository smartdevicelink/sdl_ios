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

- (void)setTryAgainTime:(NSNumber *)tryAgainTime {
    if (tryAgainTime != nil) {
        [parameters setObject:tryAgainTime forKey:SDLNameTryAgainTime];
    } else {
        [parameters removeObjectForKey:SDLNameTryAgainTime];
    }
}

- (NSNumber *)tryAgainTime {
    return [parameters objectForKey:SDLNameTryAgainTime];
}

@end
