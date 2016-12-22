//  SDLReadDID.m
//


#import "SDLReadDID.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLReadDID

- (instancetype)init {
    if (self = [super initWithName:SDLNameReadDID]) {
    }
    return self;
}

- (instancetype)initWithECUName:(UInt16)ecuName didLocation:(NSArray<NSNumber<SDLInt> *> *)didLocation {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ecuName = @(ecuName);
    self.didLocation = [didLocation mutableCopy];

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

- (void)setDidLocation:(NSMutableArray<NSNumber<SDLInt> *> *)didLocation {
    if (didLocation != nil) {
        [parameters setObject:didLocation forKey:SDLNameDIDLocation];
    } else {
        [parameters removeObjectForKey:SDLNameDIDLocation];
    }
}

- (NSMutableArray<NSNumber<SDLInt> *> *)didLocation {
    return [parameters objectForKey:SDLNameDIDLocation];
}

@end

NS_ASSUME_NONNULL_END
