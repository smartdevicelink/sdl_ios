//  SDLReadDID.m
//


#import "SDLReadDID.h"

#import "SDLNames.h"

@implementation SDLReadDID

- (instancetype)init {
    if (self = [super initWithName:SDLNameReadDid]) {
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

- (void)setDidLocation:(NSMutableArray *)didLocation {
    if (didLocation != nil) {
        [parameters setObject:didLocation forKey:SDLNameDidLocation];
    } else {
        [parameters removeObjectForKey:SDLNameDidLocation];
    }
}

- (NSMutableArray *)didLocation {
    return [parameters objectForKey:SDLNameDidLocation];
}

@end
