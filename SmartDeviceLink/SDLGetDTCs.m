//  SDLGetDTCs.m
//


#import "SDLGetDTCs.h"

#import "SDLNames.h"

@implementation SDLGetDTCs

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetDTCs]) {
    }
    return self;
}

- (void)setEcuName:(NSNumber<SDLInt> *)ecuName {
    if (ecuName != nil) {
        [parameters setObject:ecuName forKey:SDLNameECUName];
    } else {
        [parameters removeObjectForKey:SDLNameECUName];
    }
}

- (NSNumber<SDLInt> *)ecuName {
    return [parameters objectForKey:SDLNameECUName];
}

- (void)setDtcMask:(NSNumber<SDLInt> *)dtcMask {
    if (dtcMask != nil) {
        [parameters setObject:dtcMask forKey:SDLNameDTCMask];
    } else {
        [parameters removeObjectForKey:SDLNameDTCMask];
    }
}

- (NSNumber<SDLInt> *)dtcMask {
    return [parameters objectForKey:SDLNameDTCMask];
}

@end
