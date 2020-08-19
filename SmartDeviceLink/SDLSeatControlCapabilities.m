//  SDLSeatControlCapabilities.m
//

#import "SDLSeatControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSeatControlCapabilities

- (instancetype)initWithName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo {
    if (self = [super init]) {
        self.moduleName = moduleName;
        self.moduleInfo = moduleInfo;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo heatingEnabledAvailable:(BOOL)heatingEnabledAvail
     coolingEnabledAvailable:(BOOL)coolingEnabledAvail heatingLevelAvailable:(BOOL)heatingLevelAvail coolingLevelAvailable:(BOOL)coolingLevelAvail horizontalPositionAvailable:(BOOL)horizontalPositionAvail verticalPositionAvailable:(BOOL)verticalPositionAvail frontVerticalPositionAvailable:(BOOL)frontVerticalPositionAvail backVerticalPositionAvailable:(BOOL)backVerticalPositionAvail backTiltAngleAvailable:(BOOL)backTitlAngleAvail headSupportHorizontalPositionAvailable:(BOOL)headSupportHorizontalPositionAvail headSupportVerticalPositionAvailable:(BOOL)headSupportVerticalPositionAvail massageEnabledAvailable:(BOOL)massageEnabledAvail massageModeAvailable:(BOOL)massageModeAvail massageCushionFirmnessAvailable:(BOOL)massageCushionFirmnessAvail memoryAvailable:(BOOL)memoryAvail {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.moduleName = moduleName;
    self.moduleInfo = moduleInfo;
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
    [self.store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleName ofClass:NSString.class error:&error];
}

- (void)setHeatingEnabledAvailable:(nullable NSNumber<SDLBool> *)heatingEnabledAvailable {
    [self.store sdl_setObject:heatingEnabledAvailable forName:SDLRPCParameterNameHeatingEnabledAvailable];
}

- (nullable NSNumber<SDLBool> *)heatingEnabledAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatingEnabledAvailable ofClass:NSNumber.class error:nil];
}

- (void)setCoolingEnabledAvailable:(nullable NSNumber<SDLBool> *)coolingEnabledAvailable {
    [self.store sdl_setObject:coolingEnabledAvailable forName:SDLRPCParameterNameCoolingEnabledAvailable];

}

- (nullable NSNumber<SDLBool> *)coolingEnabledAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameCoolingEnabledAvailable ofClass:NSNumber.class error:nil];

}

- (void)setHeatingLevelAvailable:(nullable NSNumber<SDLBool> *)heatingLevelAvailable {
    [self.store sdl_setObject:heatingLevelAvailable forName:SDLRPCParameterNameHeatingLevelAvailable];

}

- (nullable NSNumber<SDLBool> *)heatingLevelAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatingLevelAvailable ofClass:NSNumber.class error:nil];

}

- (void)setCoolingLevelAvailable:(nullable NSNumber<SDLBool> *)coolingLevelAvailable {
    [self.store sdl_setObject:coolingLevelAvailable forName:SDLRPCParameterNameCoolingLevelAvailable];

}

- (nullable NSNumber<SDLBool> *)coolingLevelAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameCoolingLevelAvailable ofClass:NSNumber.class error:nil];

}

- (void)setHorizontalPositionAvailable:(nullable NSNumber<SDLBool> *)horizontalPositionAvailable {
    [self.store sdl_setObject:horizontalPositionAvailable forName:SDLRPCParameterNameHorizontalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)horizontalPositionAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHorizontalPositionAvailable ofClass:NSNumber.class error:nil];

}

- (void)setVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)verticalPositionAvailable {
    [self.store sdl_setObject:verticalPositionAvailable forName:SDLRPCParameterNameVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)verticalPositionAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameVerticalPositionAvailable ofClass:NSNumber.class error:nil];

}

- (void)setFrontVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)frontVerticalPositionAvailable {
    [self.store sdl_setObject:frontVerticalPositionAvailable forName:SDLRPCParameterNameFrontVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)frontVerticalPositionAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameFrontVerticalPositionAvailable ofClass:NSNumber.class error:nil];

}

- (void)setBackVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)backVerticalPositionAvailable {
    [self.store sdl_setObject:backVerticalPositionAvailable forName:SDLRPCParameterNameBackVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)backVerticalPositionAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameBackVerticalPositionAvailable ofClass:NSNumber.class error:nil];

}

- (void)setBackTiltAngleAvailable:(nullable NSNumber<SDLBool> *)backTiltAngleAvailable {
    [self.store sdl_setObject:backTiltAngleAvailable forName:SDLRPCParameterNameBackTiltAngleAvailable];

}

- (nullable NSNumber<SDLBool> *)backTiltAngleAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameBackTiltAngleAvailable ofClass:NSNumber.class error:nil];

}

- (void)setHeadSupportHorizontalPositionAvailable:(nullable NSNumber<SDLBool> *)headSupportHorizontalPositionAvailable {
    [self.store sdl_setObject:headSupportHorizontalPositionAvailable forName:SDLRPCParameterNameHeadSupportHorizontalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)headSupportHorizontalPositionAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeadSupportHorizontalPositionAvailable ofClass:NSNumber.class error:nil];

}

- (void)setHeadSupportVerticalPositionAvailable:(nullable NSNumber<SDLBool> *)headSupportVerticalPositionAvailable {
    [self.store sdl_setObject:headSupportVerticalPositionAvailable forName:SDLRPCParameterNameHeadSupportVerticalPositionAvailable];

}

- (nullable NSNumber<SDLBool> *)headSupportVerticalPositionAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeadSupportVerticalPositionAvailable ofClass:NSNumber.class error:nil];

}

- (void)setMassageEnabledAvailable:(nullable NSNumber<SDLBool> *)massageEnabledAvailable {
    [self.store sdl_setObject:massageEnabledAvailable forName:SDLRPCParameterNameMassageEnabledAvailable];

}

- (nullable NSNumber<SDLBool> *)massageEnabledAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameMassageEnabledAvailable ofClass:NSNumber.class error:nil];

}

- (void)setMassageModeAvailable:(nullable NSNumber<SDLBool> *)massageModeAvailable {
    [self.store sdl_setObject:massageModeAvailable forName:SDLRPCParameterNameMassageModeAvailable];

}

- (nullable NSNumber<SDLBool> *)massageModeAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameMassageModeAvailable ofClass:NSNumber.class error:nil];

}

- (void)setMassageCushionFirmnessAvailable:(nullable NSNumber<SDLBool> *)massageCushionFirmnessAvailable {
    [self.store sdl_setObject:massageCushionFirmnessAvailable forName:SDLRPCParameterNameMassageCushionFirmnessAvailable];

}

- (nullable NSNumber<SDLBool> *)massageCushionFirmnessAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameMassageCushionFirmnessAvailable ofClass:NSNumber.class error:nil];

}

- (void)setMemoryAvailable:(nullable NSNumber<SDLBool> *)memoryAvailable {
    [self.store sdl_setObject:memoryAvailable forName:SDLRPCParameterNameMemoryAvailable];

}

- (nullable NSNumber<SDLBool> *)memoryAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameMemoryAvailable ofClass:NSNumber.class error:nil];
}

- (void)setModuleInfo:(nullable SDLModuleInfo *)moduleInfo {
    [self.store sdl_setObject:moduleInfo forName:SDLRPCParameterNameModuleInfo];
}

- (nullable SDLModuleInfo *)moduleInfo {
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleInfo ofClass:SDLModuleInfo.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
