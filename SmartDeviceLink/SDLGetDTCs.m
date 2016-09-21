//  SDLGetDTCs.m
//


#import "SDLGetDTCs.h"



@implementation SDLGetDTCs

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetDtcs]) {
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
        [parameters setObject:ecuName forKey:SDLNameEcuName];
    } else {
        [parameters removeObjectForKey:SDLNameEcuName];
    }
}

- (NSNumber *)ecuName {
    return [parameters objectForKey:SDLNameEcuName];
}

- (void)setDtcMask:(NSNumber *)dtcMask {
    if (dtcMask != nil) {
        [parameters setObject:dtcMask forKey:SDLNameDtcMask];
    } else {
        [parameters removeObjectForKey:SDLNameDtcMask];
    }
}

- (NSNumber *)dtcMask {
    return [parameters objectForKey:SDLNameDtcMask];
}

@end
