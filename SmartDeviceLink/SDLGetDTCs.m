//  SDLGetDTCs.m
//


#import "SDLGetDTCs.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:ecuName forName:SDLNameECUName];
}

- (NSNumber<SDLInt> *)ecuName {
    return [parameters sdl_objectForName:SDLNameECUName];
}

- (void)setDtcMask:(nullable NSNumber<SDLInt> *)dtcMask {
    [parameters sdl_setObject:dtcMask forName:SDLNameDTCMask];
}

- (nullable NSNumber<SDLInt> *)dtcMask {
    return [parameters sdl_objectForName:SDLNameDTCMask];
}

@end

NS_ASSUME_NONNULL_END
