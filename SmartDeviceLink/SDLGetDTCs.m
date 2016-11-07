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

- (instancetype)initWithECUName:(UInt16)name mask:(UInt8)mask {
    self = [self initWithECUName:name];
    if (!self) {
        return nil;
    }

    self.dtcMask = @(mask);

    return self;
}

- (instancetype)initWithECUName:(UInt16)name {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ecuName = @(name);

    return self;
}

- (void)setEcuName:(NSNumber<SDLInt> *)ecuName {
    [self setObject:ecuName forName:SDLNameECUName];
}

- (NSNumber<SDLInt> *)ecuName {
    return [parameters objectForKey:SDLNameECUName];
}

- (void)setDtcMask:(NSNumber<SDLInt> *)dtcMask {
    [self setObject:dtcMask forName:SDLNameDTCMask];
}

- (NSNumber<SDLInt> *)dtcMask {
    return [parameters objectForKey:SDLNameDTCMask];
}

@end
