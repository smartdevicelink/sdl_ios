//  SDLSeatControlCapabilities.m
//

#import "SDLSeatControlCapabilities.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSeatControlCapabilities

- (instancetype)initWithName:(NSString *)moduleName {
    if (self = [super init]) {
        self.moduleName = moduleName;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)moduleName heatingEnabledAvailable:(BOOL)heatingEnabledAvail coolingEnabledAvailable:(BOOL)coolingEnabledAvail heatingLevelAvailable:(BOOL)heatingLevelAvail coolingLevelAvailable:(BOOL)coolingLevelAvail horizontalPositionAvailable:(BOOL)horizontalPositionAvail verticalPositionAvailable:(BOOL)verticalPositionAvail frontVerticalPositionAvailable:(BOOL)frontVerticalPositionAvail backVerticalPositionAvailable:(BOOL)backVerticalPositionAvail backTiltAngleAvailable:(BOOL)backTitlAngleAvail headSupportHorizontalPositionAvailable:(BOOL)headSupportHorizontalPositionAvail headSupportVerticalPositionAvailable:(BOOL)headSupportVerticalPositionAvail massageEnabledAvailable:(BOOL)massageEnabledAvail massageModeAvailable:(BOOL)massageModeAvail massageCushionFirmnessAvailable:(BOOL)massageCushionFirmnessAvail memoryAvailable:(BOOL)memoryAvail {

    self = [super init];
    if (!self) {
        return nil;
    }

    self.moduleName = moduleName;
    self.heatingEnabledAvailable = @(heatingEnabledAvail);
    self.coolingEnabledAvailable = @(coolingEnabledAvail);
    self.heatingLevelAvailable = @(heatingLevelAvail);
    self.coolingLevelAvailable = @(coolingLevelAvail);
    self.horizontalPositionAvailable = @(horizontalPositionAvail);
    self.verticalPositionAvailable = @(verticalPositionAvail);
    self.frontVerticalPositionAvailable = @(frontVerticalPositionAvail);
    self.backVerticalPositionAvailable = @(backVerticalPositionAvail);
    self.backTiltAngleAvailable = @(backTitlAngleAvail);
    self.headSupportVerticalPositionAvailable = @(headSupportVerticalPositionAvail);
    self.headSupportHorizontalPositionAvailable = @(headSupportHorizontalPositionAvail);
    self.massageEnabledAvailable = @(massageEnabledAvail);
    self.massageModeAvailable = @(massageModeAvail);
    self.massageCushionFirmnessAvailable = @(massageCushionFirmnessAvail);
    self.memoryAvailable = @(memoryAvail);

    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [store sdl_setObject:moduleName forName:SDLNameModuleName];
}

- (NSString *)moduleName {
    return [store sdl_objectForName:SDLNameModuleName];
}

- (void)setHeatingEnabledAvailable:(nullable NSNumber<SDLBool> *)heatingEnabledAvailable {
    [store sdl_setObject:heatingEnabledAvailable forName:SDLNameHeatingEnabledAvailable];
}

- (nullable NSNumber<SDLBool> *)heatingEnabledAvailable {
    return [store sdl_objectForName:SDLNameHeatingEnabledAvailable];
}

- (void)setCoolingEnabledAvailable:(nullable NSNumber<SDLBool> *)coolingEnabledAvailable {
    [store sdl_setObject:coolingEnabledAvailable forName:SDLNameCoolingEnabledAvailable];

}

- (nullable NSNumber<SDLBool> *)coolingEnabledAvailable {
    return [store sdl_objectForName:SDLNameCoolingEnabledAvailable];

}

- (void)setHeatingLevelAvailable:(nullable NSNumber<SDLBool> *)heatingLevelAvailable {
    [store sdl_setObject:heatingLevelAvailable forName:SDLNameHeatingLevelAvailable];

}

- (nullable NSNumber<SDLBool> *)heatingLevelAvailable {
    return [store sdl_objectForName:SDLNameHeatingLevelAvailable];

}

- (void)setCoolingLevelAvailable:(nullable NSNumber<SDLBool> *)coolingLevelAvailable {
    [store sdl_setObject:coolingLevelAvailable forName:SDLNameCoolingLevelAvailable];

}

- (nullable NSNumber<SDLBool> *)coolingLevelAvailable {
    return [store sdl_objectForName:SDLNameCoolingLevelAvailable];

}

- (void)setHorizontalPositionAvailable:(nullable NSNumber<SDLBool> *)horizontalPositionAvailable {
    [store sdl_setObject:horizontalPositionAvailable forName:SDLNameHorizontalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)horizontalPositionAvailable {
    return [store sdl_objectForName:SDLNameHorizontalPositionAvailable];

}

- (void)setVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)verticalPositionAvailable {
    [store sdl_setObject:verticalPositionAvailable forName:SDLNameVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)verticalPositionAvailable {
    return [store sdl_objectForName:SDLNameVerticalPositionAvailable];

}

- (void)setFrontVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)frontVerticalPositionAvailable {
    [store sdl_setObject:frontVerticalPositionAvailable forName:SDLNameFrontVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)frontVerticalPositionAvailable {
    return [store sdl_objectForName:SDLNameFrontVerticalPositionAvailable];

}

- (void)setBackVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)backVerticalPositionAvailable {
    [store sdl_setObject:backVerticalPositionAvailable forName:SDLNameBackVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)backVerticalPositionAvailable {
    return [store sdl_objectForName:SDLNameBackVerticalPositionAvailable];

}

- (void)setBackTiltAngleAvailable:(nullable NSNumber<SDLBool> *)backTiltAngleAvailable {
    [store sdl_setObject:backTiltAngleAvailable forName:SDLNameBackTiltAngleAvailable];

}

- (nullable NSNumber<SDLBool> *)backTiltAngleAvailable {
    return [store sdl_objectForName:SDLNameBackTiltAngleAvailable];

}

- (void)setHeadSupportHorizontalPositionAvailable:(nullable NSNumber<SDLBool> *)headSupportHorizontalPositionAvailable {
    [store sdl_setObject:headSupportHorizontalPositionAvailable forName:SDLNameHeadSupportHorizontalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)headSupportHorizontalPositionAvailable {
    return [store sdl_objectForName:SDLNameHeadSupportHorizontalPositionAvailable];

}

- (void)setHeadSupportVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)headSupportVerticalPositionAvailable {
    [store sdl_setObject:headSupportVerticalPositionAvailable forName:SDLNameHeadSupportVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)headSupportVerticalPositionAvailable {
    return [store sdl_objectForName:SDLNameHeadSupportVerticalPositionAvailable];

}

- (void)setMassageEnabledAvailable:(nullable NSNumber<SDLBool> *)massageEnabledAvailable {
    [store sdl_setObject:massageEnabledAvailable forName:SDLNameMassageEnabledAvailable];

}

- (nullable NSNumber<SDLBool> *)massageEnabledAvailable {
    return [store sdl_objectForName:SDLNameMassageEnabledAvailable];

}

- (void)setMassageModeAvailable:(nullable NSNumber<SDLBool> *)massageModeAvailable {
    [store sdl_setObject:massageModeAvailable forName:SDLNameMassageModeAvailable];

}

- (nullable NSNumber<SDLBool> *)massageModeAvailable {
    return [store sdl_objectForName:SDLNameMassageModeAvailable];

}

- (void)setMassageCushionFirmnessAvailable:(nullable NSNumber<SDLBool> *)massageCushionFirmnessAvailable {
    [store sdl_setObject:massageCushionFirmnessAvailable forName:SDLNameMassageCushionFirmnessAvailable];

}

- (nullable NSNumber<SDLBool> *)massageCushionFirmnessAvailable {
    return [store sdl_objectForName:SDLNameMassageCushionFirmnessAvailable];

}

- (void)setMemoryAvailable:(nullable NSNumber<SDLBool> *)memoryAvailable {
    [store sdl_setObject:memoryAvailable forName:SDLNameMemoryAvailable];

}

- (nullable NSNumber<SDLBool> *)memoryAvailable {
    return [store sdl_objectForName:SDLNameMemoryAvailable];
}

@end

NS_ASSUME_NONNULL_END
