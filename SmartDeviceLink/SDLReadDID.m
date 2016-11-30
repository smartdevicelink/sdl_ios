//  SDLReadDID.m
//


#import "SDLReadDID.h"

#import "SDLNames.h"

@implementation SDLReadDID

- (instancetype)init {
    if (self = [super initWithName:NAMES_ReadDID]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithECUName:(UInt16)ecuName didLocation:(NSArray<NSNumber<SDLUInt> *> *)didLocation {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ecuName = @(ecuName);
    self.didLocation = [didLocation mutableCopy];

    return self;
}

- (void)setEcuName:(NSNumber *)ecuName {
    if (ecuName != nil) {
        [parameters setObject:ecuName forKey:NAMES_ecuName];
    } else {
        [parameters removeObjectForKey:NAMES_ecuName];
    }
}

- (NSNumber *)ecuName {
    return [parameters objectForKey:NAMES_ecuName];
}

- (void)setDidLocation:(NSMutableArray *)didLocation {
    if (didLocation != nil) {
        [parameters setObject:didLocation forKey:NAMES_didLocation];
    } else {
        [parameters removeObjectForKey:NAMES_didLocation];
    }
}

- (NSMutableArray *)didLocation {
    return [parameters objectForKey:NAMES_didLocation];
}

@end
