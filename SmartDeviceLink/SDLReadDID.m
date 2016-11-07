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
    [self setObject:ecuName forName:SDLNameECUName];
}

- (NSNumber<SDLInt> *)ecuName {
    return [parameters objectForKey:SDLNameECUName];
}

- (void)setDidLocation:(NSMutableArray<NSNumber<SDLInt> *> *)didLocation {
    [self setObject:didLocation forName:SDLNameDIDLocation];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)didLocation {
    return [parameters objectForKey:SDLNameDIDLocation];
}

@end
