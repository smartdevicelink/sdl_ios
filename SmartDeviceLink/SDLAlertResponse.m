//  SDLAlertResponse.m
//

#import "SDLAlertResponse.h"

#import "SDLNames.h"

@implementation SDLAlertResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_Alert]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setTryAgainTime:(NSNumber *)tryAgainTime {
    if (tryAgainTime != nil) {
        [parameters setObject:tryAgainTime forKey:NAMES_tryAgainTime];
    } else {
        [parameters removeObjectForKey:NAMES_tryAgainTime];
    }
}

- (NSNumber *)tryAgainTime {
    return [parameters objectForKey:NAMES_tryAgainTime];
}

@end
