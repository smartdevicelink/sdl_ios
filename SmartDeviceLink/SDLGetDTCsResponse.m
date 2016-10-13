//  SDLGetDTCsResponse.m
//


#import "SDLGetDTCsResponse.h"

#import "SDLNames.h"

@implementation SDLGetDTCsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetDTCs]) {
    }
    return self;
}

- (void)setEcuHeader:(NSNumber *)ecuHeader {
    if (ecuHeader != nil) {
        [parameters setObject:ecuHeader forKey:SDLNameECUHeader];
    } else {
        [parameters removeObjectForKey:SDLNameECUHeader];
    }
}

- (NSNumber *)ecuHeader {
    return [parameters objectForKey:SDLNameECUHeader];
}

- (void)setDtc:(NSMutableArray *)dtc {
    if (dtc != nil) {
        [parameters setObject:dtc forKey:SDLNameDTC];
    } else {
        [parameters removeObjectForKey:SDLNameDTC];
    }
}

- (NSMutableArray *)dtc {
    return [parameters objectForKey:SDLNameDTC];
}

@end
