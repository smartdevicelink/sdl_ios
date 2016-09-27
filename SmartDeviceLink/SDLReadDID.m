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

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
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

- (void)setDidLocation:(NSMutableArray<NSNumber *> *)didLocation {
    if (didLocation != nil) {
        [parameters setObject:didLocation forKey:SDLNameDIDLocation];
    } else {
        [parameters removeObjectForKey:SDLNameDIDLocation];
    }
}

- (NSMutableArray<NSNumber *> *)didLocation {
    return [parameters objectForKey:SDLNameDIDLocation];
}

@end
