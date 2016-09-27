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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setEcuName:(NSNumber *)ecuName {
    if (ecuName != nil) {
        [parameters setObject:ecuName forKey:SDLNameECUName];
    } else {
        [parameters removeObjectForKey:SDLNameECUName];
    }
}

- (NSNumber *)ecuName {
    return [parameters objectForKey:SDLNameECUName];
}

- (void)setDtcMask:(NSNumber *)dtcMask {
    if (dtcMask != nil) {
        [parameters setObject:dtcMask forKey:SDLNameDTCMask];
    } else {
        [parameters removeObjectForKey:SDLNameDTCMask];
    }
}

- (NSNumber *)dtcMask {
    return [parameters objectForKey:SDLNameDTCMask];
}

@end
