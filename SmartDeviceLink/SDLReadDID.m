//  SDLReadDID.m
//


#import "SDLReadDID.h"

#import "SDLNames.h"

@implementation SDLReadDID

- (instancetype)init {
    if (self = [super initWithName:SDLNameReadDID]) {
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

- (void)setDidLocation:(NSMutableArray *)didLocation {
    if (didLocation != nil) {
        [parameters setObject:didLocation forKey:SDLNameDIDLocation];
    } else {
        [parameters removeObjectForKey:SDLNameDIDLocation];
    }
}

- (NSMutableArray *)didLocation {
    return [parameters objectForKey:SDLNameDIDLocation];
}

@end
