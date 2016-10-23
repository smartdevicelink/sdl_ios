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

- (void)setEcuHeader:(NSNumber<SDLInt> *)ecuHeader {
    if (ecuHeader != nil) {
        [parameters setObject:ecuHeader forKey:SDLNameECUHeader];
    } else {
        [parameters removeObjectForKey:SDLNameECUHeader];
    }
}

- (NSNumber<SDLInt> *)ecuHeader {
    return [parameters objectForKey:SDLNameECUHeader];
}

- (void)setDtc:(NSMutableArray<NSString *> *)dtc {
    if (dtc != nil) {
        [parameters setObject:dtc forKey:SDLNameDTC];
    } else {
        [parameters removeObjectForKey:SDLNameDTC];
    }
}

- (NSMutableArray<NSString *> *)dtc {
    return [parameters objectForKey:SDLNameDTC];
}

@end
