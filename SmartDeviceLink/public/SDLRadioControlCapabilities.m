//
//  SDLRadioControlCapabilities.m
//

#import "SDLRadioControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRadioControlCapabilities

- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo radioEnableAvailable:(BOOL)radioEnableAvailable radioBandAvailable:(BOOL)radioBandAvailable radioFrequencyAvailable:(BOOL)radioFrequencyAvailable hdChannelAvailable:(BOOL)hdChannelAvailable rdsDataAvailable:(BOOL)rdsDataAvailable availableHDChannelsAvailable:(BOOL)availableHDChannelsAvailable stateAvailable:(BOOL)stateAvailable signalStrengthAvailable:(BOOL)signalStrengthAvailable signalChangeThresholdAvailable:(BOOL)signalChangeThresholdAvailable hdRadioEnableAvailable:(BOOL)hdRadioEnableAvailable siriusXMRadioAvailable:(BOOL)siriusXMRadioAvailable sisDataAvailable:(BOOL)sisDataAvailable {
    self = [self init];
    if(!self){
        return nil;
    }
    
    self.moduleName = moduleName;
    self.moduleInfo = moduleInfo;
    self.radioEnableAvailable = @(radioEnableAvailable);
    self.radioBandAvailable = @(radioBandAvailable);
    self.radioFrequencyAvailable = @(radioFrequencyAvailable);
    self.hdChannelAvailable = @(hdChannelAvailable);
    self.rdsDataAvailable = @(rdsDataAvailable);
    self.availableHDChannelsAvailable = @(availableHDChannelsAvailable);
    self.stateAvailable = @(stateAvailable);
    self.signalStrengthAvailable = @(signalStrengthAvailable);
    self.signalChangeThresholdAvailable = @(signalChangeThresholdAvailable);
    self.hdRadioEnableAvailable = @(hdRadioEnableAvailable);
    self.siriusXMRadioAvailable = @(siriusXMRadioAvailable);
    self.sisDataAvailable = @(sisDataAvailable);
    
    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [self.store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleName ofClass:NSString.class error:&error];
}

- (void)setRadioEnableAvailable:(nullable NSNumber<SDLBool> *)radioEnableAvailable {
    [self.store sdl_setObject:radioEnableAvailable forName:SDLRPCParameterNameRadioEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)radioEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameRadioEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setRadioBandAvailable:(nullable NSNumber<SDLBool> *)radioBandAvailable {
    [self.store sdl_setObject:radioBandAvailable forName:SDLRPCParameterNameRadioBandAvailable];
}

- (nullable NSNumber<SDLBool> *)radioBandAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameRadioBandAvailable ofClass:NSNumber.class error:nil];
}

- (void)setRadioFrequencyAvailable:(nullable NSNumber<SDLBool> *)radioFrequencyAvailable {
    [self.store sdl_setObject:radioFrequencyAvailable forName:SDLRPCParameterNameRadioFrequencyAvailable];
}

- (nullable NSNumber<SDLBool> *)radioFrequencyAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameRadioFrequencyAvailable ofClass:NSNumber.class error:nil];
}

- (void)setHdChannelAvailable:(nullable NSNumber<SDLBool> *)hdChannelAvailable {
    [self.store sdl_setObject:hdChannelAvailable forName:SDLRPCParameterNameHDChannelAvailable];
}

- (nullable NSNumber<SDLBool> *)hdChannelAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHDChannelAvailable ofClass:NSNumber.class error:nil];
}

- (void)setRdsDataAvailable:(nullable NSNumber<SDLBool> *)rdsDataAvailable {
    [self.store sdl_setObject:rdsDataAvailable forName:SDLRPCParameterNameRDSDataAvailable];
}

- (nullable NSNumber<SDLBool> *)rdsDataAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameRDSDataAvailable ofClass:NSNumber.class error:nil];
}

- (void)setAvailableHDsAvailable:(nullable NSNumber<SDLBool> *)availableHDsAvailable {
    [self.store sdl_setObject:availableHDsAvailable forName:SDLRPCParameterNameAvailableHDsAvailable];
}

- (nullable NSNumber<SDLBool> *)availableHDsAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameAvailableHDsAvailable ofClass:NSNumber.class error:nil];
}

- (void)setAvailableHDChannelsAvailable:(nullable NSNumber<SDLBool> *)availableHDChannelsAvailable {
    [self.store sdl_setObject:availableHDChannelsAvailable forName:SDLRPCParameterNameAvailableHDsAvailable];
}

- (nullable NSNumber<SDLBool> *)availableHDChannelsAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameAvailableHDsAvailable ofClass:NSNumber.class error:nil];
}

- (void)setStateAvailable:(nullable NSNumber<SDLBool> *)stateAvailable {
    [self.store sdl_setObject:stateAvailable forName:SDLRPCParameterNameStateAvailable];
}

- (nullable NSNumber<SDLBool> *)stateAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameStateAvailable ofClass:NSNumber.class error:nil];
}

- (void)setSignalStrengthAvailable:(nullable NSNumber<SDLBool> *)signalStrengthAvailable {
    [self.store sdl_setObject:signalStrengthAvailable forName:SDLRPCParameterNameSignalStrengthAvailable];
}

- (nullable NSNumber<SDLBool> *)signalStrengthAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameSignalStrengthAvailable ofClass:NSNumber.class error:nil];
}

- (void)setSignalChangeThresholdAvailable:(nullable NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    [self.store sdl_setObject:signalChangeThresholdAvailable forName:SDLRPCParameterNameSignalChangeThresholdAvailable];
}

- (nullable NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameSignalChangeThresholdAvailable ofClass:NSNumber.class error:nil];
}

- (void)setHdRadioEnableAvailable:(nullable NSNumber<SDLBool> *)hdRadioEnableAvailable {
    [self.store sdl_setObject:hdRadioEnableAvailable forName:SDLRPCParameterNameHDRadioEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)hdRadioEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHDRadioEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setSiriusXMRadioAvailable:(nullable NSNumber<SDLBool> *)siriusXMRadioAvailable {
    [self.store sdl_setObject:siriusXMRadioAvailable forName:SDLRPCParameterNameSiriusXMRadioAvailable];
}

- (nullable NSNumber<SDLBool> *)siriusXMRadioAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameSiriusXMRadioAvailable ofClass:NSNumber.class error:nil];
}

- (void)setSisDataAvailable:(nullable NSNumber<SDLBool> *)sisDataAvailable {
    [self.store sdl_setObject:sisDataAvailable forName:SDLRPCParameterNameSISDataAvailable];
}

- (nullable NSNumber<SDLBool> *)sisDataAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameSISDataAvailable ofClass:NSNumber.class error:nil];
}

- (void)setModuleInfo:(nullable SDLModuleInfo *)moduleInfo {
    [self.store sdl_setObject:moduleInfo forName:SDLRPCParameterNameModuleInfo];
}

- (nullable SDLModuleInfo *)moduleInfo {
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleInfo ofClass:SDLModuleInfo.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
