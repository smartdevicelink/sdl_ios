//
//  SDLRdsData.m
//

#import "SDLRdsData.h"
#include "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRdsData

- (instancetype)initWithProgramService:(nullable NSString *)PS {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.PS = PS;
    return self;
}

- (instancetype)initWithRadioText:(nullable NSString *)RT {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.RT = RT;
    return self;
}

- (instancetype)initWithClockText:(nullable NSString *)CT {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.CT = CT;
    return self;
}

- (instancetype)initWithProgramIdentification:(nullable NSString *)PI {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.PI = PI;
    return self;
}

- (instancetype)initWithProgramType:(nullable NSNumber<SDLInt> *)PTY {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.PTY = PTY;
    return self;
}

- (instancetype)initWithTrafficProgramIdentification:(nullable NSNumber<SDLBool> *)TP {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.TP = TP;
    return self;
}

- (instancetype)initWithTrafficAnnouncementIdentification:(nullable NSNumber<SDLBool> *)TA {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.TA = TA;
    return self;
}

- (instancetype)initWithRegion:(nullable NSString *)REG {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.REG = REG;
    return self;
}

- (void)setPS:(nullable NSString *)PS {
    [store sdl_setObject:PS forName:SDLNamePS];
}

- (nullable NSString *)PS {
    return [store sdl_objectForName:SDLNamePS];
}

- (void)setRT:(nullable NSString *)RT {
    [store sdl_setObject:RT forName:SDLNameRT];
}

- (nullable NSString *)RT {
    return [store sdl_objectForName:SDLNameRT];
}

- (void)setCT:(nullable NSString *)CT {
    [store sdl_setObject:CT forName:SDLNameCT];
}

- (nullable NSString *)CT {
    return [store sdl_objectForName:SDLNameCT];
}

- (void)setPI:(nullable NSString *)PI {
    [store sdl_setObject:PI forName:SDLNamePI];
}

- (nullable NSString *)PI {
    return [store sdl_objectForName:SDLNamePI];
}

- (void)setPTY:(nullable NSNumber<SDLInt> *)PTY {
    [store sdl_setObject:PTY forName:SDLNamePTY];
}

- (nullable NSNumber<SDLInt> *)PTY {
    return [store sdl_objectForName:SDLNamePTY];
}

- (void)setTP:(nullable NSNumber<SDLBool> *)TP {
    [store sdl_setObject:TP forName:SDLNameTP];
}

- (nullable NSNumber<SDLBool> *)TP {
    return [store sdl_objectForName:SDLNameTP];
}

- (void)setTA:(nullable NSNumber<SDLBool> *)TA {
    [store sdl_setObject:TA forName:SDLNameTA];
}

- (nullable NSNumber<SDLBool> *)TA {
    return [store sdl_objectForName:SDLNameTA];
}

- (void)setREG:(nullable NSString *)REG {
    [store sdl_setObject:REG forName:SDLNameREG];
}

- (nullable NSString *)REG {
    return [store sdl_objectForName:SDLNameREG];
}
@end

NS_ASSUME_NONNULL_END
