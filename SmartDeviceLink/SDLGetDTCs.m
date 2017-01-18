//  SDLGetDTCs.m
//


#import "SDLGetDTCs.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
    if (ecuName != nil) {
        [parameters setObject:ecuName forKey:SDLNameECUName];
    } else {
        [parameters removeObjectForKey:SDLNameECUName];
    }
}

- (NSNumber<SDLInt> *)ecuName {
    return [parameters objectForKey:SDLNameECUName];
}

- (void)setDtcMask:(nullable NSNumber<SDLInt> *)dtcMask {
    if (dtcMask != nil) {
        [parameters setObject:dtcMask forKey:SDLNameDTCMask];
    } else {
        [parameters removeObjectForKey:SDLNameDTCMask];
    }
}

- (nullable NSNumber<SDLInt> *)dtcMask {
    return [parameters objectForKey:SDLNameDTCMask];
}

@end

NS_ASSUME_NONNULL_END
