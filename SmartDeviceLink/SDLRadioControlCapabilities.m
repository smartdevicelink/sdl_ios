//
//  SDLRadioControlCapabilities.m
//

#import "SDLRadioControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRadioControlCapabilities

- (instancetype)initWithModuleName:(NSString *)moduleName radioEnableAvailable:(BOOL)radioEnableAvailable radioBandAvailable:(BOOL)radioBandAvailable radioFrequencyAvailable:(BOOL)radioFrequencyAvailable hdChannelAvailable:(BOOL)hdChannelAvailable rdsDataAvailable:(BOOL)rdsDataAvailable availableHDsAvailable:(BOOL)availableHDsAvailable stateAvailable:(BOOL)stateAvailable signalStrengthAvailable:(BOOL)signalStrengthAvailable signalChangeThresholdAvailable:(BOOL)signalChangeThresholdAvailable {
    return [self initWithModuleName:moduleName radioEnableAvailable:radioEnableAvailable radioBandAvailable:radioBandAvailable radioFrequencyAvailable:radioFrequencyAvailable hdChannelAvailable:hdChannelAvailable rdsDataAvailable:rdsDataAvailable availableHDsAvailable:availableHDsAvailable stateAvailable:stateAvailable signalStrengthAvailable:signalStrengthAvailable signalChangeThresholdAvailable:signalChangeThresholdAvailable hdRadioEnableAvailable:NO siriusXMRadioAvailable:NO sisDataAvailable:NO];
}

- (instancetype)initWithModuleName:(NSString *)moduleName radioEnableAvailable:(BOOL)radioEnableAvailable radioBandAvailable:(BOOL)radioBandAvailable radioFrequencyAvailable:(BOOL)radioFrequencyAvailable hdChannelAvailable:(BOOL)hdChannelAvailable rdsDataAvailable:(BOOL)rdsDataAvailable availableHDsAvailable:(BOOL)availableHDsAvailable stateAvailable:(BOOL)stateAvailable signalStrengthAvailable:(BOOL)signalStrengthAvailable signalChangeThresholdAvailable:(BOOL)signalChangeThresholdAvailable hdRadioEnableAvailable:(BOOL)hdRadioEnableAvailable siriusXMRadioAvailable:(BOOL)siriusXMRadioAvailable sisDataAvailable:(BOOL)sisDataAvailable {
    self = [self init];
    if(!self){
        return nil;
    }
    
    self.moduleName = moduleName;
    self.radioEnableAvailable = @(radioEnableAvailable);
    self.radioBandAvailable = @(radioBandAvailable);
    self.radioFrequencyAvailable = @(radioFrequencyAvailable);
    self.hdChannelAvailable = @(hdChannelAvailable);
    self.rdsDataAvailable = @(rdsDataAvailable);
    self.availableHDsAvailable = @(availableHDsAvailable);
    self.stateAvailable = @(stateAvailable);
    self.signalStrengthAvailable = @(signalStrengthAvailable);
    self.signalChangeThresholdAvailable = @(signalChangeThresholdAvailable);
    self.hdRadioEnableAvailable = @(hdRadioEnableAvailable);
    self.siriusXMRadioAvailable = @(siriusXMRadioAvailable);
    self.sisDataAvailable = @(sisDataAvailable);
    
    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    return [store sdl_objectForName:SDLRPCParameterNameModuleName];
}

- (void)setRadioEnableAvailable:(nullable NSNumber<SDLBool> *)radioEnableAvailable {
    [store sdl_setObject:radioEnableAvailable forName:SDLRPCParameterNameRadioEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)radioEnableAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameRadioEnableAvailable];
}

- (void)setRadioBandAvailable:(nullable NSNumber<SDLBool> *)radioBandAvailable {
    [store sdl_setObject:radioBandAvailable forName:SDLRPCParameterNameRadioBandAvailable];
}

- (nullable NSNumber<SDLBool> *)radioBandAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameRadioBandAvailable];
}

- (void)setRadioFrequencyAvailable:(nullable NSNumber<SDLBool> *)radioFrequencyAvailable {
    [store sdl_setObject:radioFrequencyAvailable forName:SDLRPCParameterNameRadioFrequencyAvailable];
}

- (nullable NSNumber<SDLBool> *)radioFrequencyAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameRadioFrequencyAvailable];
}

- (void)setHdChannelAvailable:(nullable NSNumber<SDLBool> *)hdChannelAvailable {
    [store sdl_setObject:hdChannelAvailable forName:SDLRPCParameterNameHDChannelAvailable];
}

- (nullable NSNumber<SDLBool> *)hdChannelAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameHDChannelAvailable];
}

- (void)setRdsDataAvailable:(nullable NSNumber<SDLBool> *)rdsDataAvailable {
    [store sdl_setObject:rdsDataAvailable forName:SDLRPCParameterNameRDSDataAvailable];
}

- (nullable NSNumber<SDLBool> *)rdsDataAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameRDSDataAvailable];
}

- (void)setAvailableHDsAvailable:(nullable NSNumber<SDLBool> *)availableHDsAvailable {
    [store sdl_setObject:availableHDsAvailable forName:SDLRPCParameterNameAvailableHDsAvailable];
}

- (nullable NSNumber<SDLBool> *)availableHDsAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameAvailableHDsAvailable];
}

- (void)setStateAvailable:(nullable NSNumber<SDLBool> *)stateAvailable {
    [store sdl_setObject:stateAvailable forName:SDLRPCParameterNameStateAvailable];
}

- (nullable NSNumber<SDLBool> *)stateAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameStateAvailable];
}

- (void)setSignalStrengthAvailable:(nullable NSNumber<SDLBool> *)signalStrengthAvailable {
    [store sdl_setObject:signalStrengthAvailable forName:SDLRPCParameterNameSignalStrengthAvailable];
}

- (nullable NSNumber<SDLBool> *)signalStrengthAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameSignalStrengthAvailable];
}

- (void)setSignalChangeThresholdAvailable:(nullable NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    [store sdl_setObject:signalChangeThresholdAvailable forName:SDLRPCParameterNameSignalChangeThresholdAvailable];
}

- (nullable NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameSignalChangeThresholdAvailable];
}

- (void)setHdRadioEnableAvailable:(nullable NSNumber<SDLBool> *)hdRadioEnableAvailable {
    [store sdl_setObject:hdRadioEnableAvailable forName:SDLRPCParameterNameHDRadioEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)hdRadioEnableAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameHDRadioEnableAvailable];
}

- (void)setSiriusXMRadioAvailable:(nullable NSNumber<SDLBool> *)siriusXMRadioAvailable {
    [store sdl_setObject:siriusXMRadioAvailable forName:SDLRPCParameterNameSiriusXMRadioAvailable];
}

- (nullable NSNumber<SDLBool> *)siriusXMRadioAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameSiriusXMRadioAvailable];
}

- (void)setSisDataAvailable:(nullable NSNumber<SDLBool> *)sisDataAvailable {
    [store sdl_setObject:sisDataAvailable forName:SDLRPCParameterNameSISDataAvailable];
}

- (nullable NSNumber<SDLBool> *)sisDataAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameSISDataAvailable];
}

@end

NS_ASSUME_NONNULL_END
