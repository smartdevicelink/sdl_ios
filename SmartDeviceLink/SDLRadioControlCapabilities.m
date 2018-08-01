//
//  SDLRadioControlCapabilities.m
//

#import "SDLRadioControlCapabilities.h"
#import "SDLNames.h"
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
    [store sdl_setObject:moduleName forName:SDLNameModuleName];
}

- (NSString *)moduleName {
    return [store sdl_objectForName:SDLNameModuleName];
}

- (void)setRadioEnableAvailable:(nullable NSNumber<SDLBool> *)radioEnableAvailable {
    [store sdl_setObject:radioEnableAvailable forName:SDLNameRadioEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)radioEnableAvailable {
    return [store sdl_objectForName:SDLNameRadioEnableAvailable];
}

- (void)setRadioBandAvailable:(nullable NSNumber<SDLBool> *)radioBandAvailable {
    [store sdl_setObject:radioBandAvailable forName:SDLNameRadioBandAvailable];
}

- (nullable NSNumber<SDLBool> *)radioBandAvailable {
    return [store sdl_objectForName:SDLNameRadioBandAvailable];
}

- (void)setRadioFrequencyAvailable:(nullable NSNumber<SDLBool> *)radioFrequencyAvailable {
    [store sdl_setObject:radioFrequencyAvailable forName:SDLNameRadioFrequencyAvailable];
}

- (nullable NSNumber<SDLBool> *)radioFrequencyAvailable {
    return [store sdl_objectForName:SDLNameRadioFrequencyAvailable];
}

- (void)setHdChannelAvailable:(nullable NSNumber<SDLBool> *)hdChannelAvailable {
    [store sdl_setObject:hdChannelAvailable forName:SDLNameHDChannelAvailable];
}

- (nullable NSNumber<SDLBool> *)hdChannelAvailable {
    return [store sdl_objectForName:SDLNameHDChannelAvailable];
}

- (void)setRdsDataAvailable:(nullable NSNumber<SDLBool> *)rdsDataAvailable {
    [store sdl_setObject:rdsDataAvailable forName:SDLNameRDSDataAvailable];
}

- (nullable NSNumber<SDLBool> *)rdsDataAvailable {
    return [store sdl_objectForName:SDLNameRDSDataAvailable];
}

- (void)setAvailableHDsAvailable:(nullable NSNumber<SDLBool> *)availableHDsAvailable {
    [store sdl_setObject:availableHDsAvailable forName:SDLNameAvailableHDsAvailable];
}

- (nullable NSNumber<SDLBool> *)availableHDsAvailable {
    return [store sdl_objectForName:SDLNameAvailableHDsAvailable];
}

- (void)setStateAvailable:(nullable NSNumber<SDLBool> *)stateAvailable {
    [store sdl_setObject:stateAvailable forName:SDLNameStateAvailable];
}

- (nullable NSNumber<SDLBool> *)stateAvailable {
    return [store sdl_objectForName:SDLNameStateAvailable];
}

- (void)setSignalStrengthAvailable:(nullable NSNumber<SDLBool> *)signalStrengthAvailable {
    [store sdl_setObject:signalStrengthAvailable forName:SDLNameSignalStrengthAvailable];
}

- (nullable NSNumber<SDLBool> *)signalStrengthAvailable {
    return [store sdl_objectForName:SDLNameSignalStrengthAvailable];
}

- (void)setSignalChangeThresholdAvailable:(nullable NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    [store sdl_setObject:signalChangeThresholdAvailable forName:SDLNameSignalChangeThresholdAvailable];
}

- (nullable NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    return [store sdl_objectForName:SDLNameSignalChangeThresholdAvailable];
}

- (void)setHdRadioEnableAvailable:(nullable NSNumber<SDLBool> *)hdRadioEnableAvailable {
    [store sdl_setObject:hdRadioEnableAvailable forName:SDLNameHDRadioEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)hdRadioEnableAvailable {
    return [store sdl_objectForName:SDLNameHDRadioEnableAvailable];
}

- (void)setSiriusXMRadioAvailable:(nullable NSNumber<SDLBool> *)siriusXMRadioAvailable {
    [store sdl_setObject:siriusXMRadioAvailable forName:SDLNameSiriusXMRadioAvailable];
}

- (nullable NSNumber<SDLBool> *)siriusXMRadioAvailable {
    return [store sdl_objectForName:SDLNameSiriusXMRadioAvailable];
}

- (void)setSisDataAvailable:(nullable NSNumber<SDLBool> *)sisDataAvailable {
    [store sdl_setObject:sisDataAvailable forName:SDLNameSISDataAvailable];
}

- (nullable NSNumber<SDLBool> *)sisDataAvailable {
    return [store sdl_objectForName:SDLNameSISDataAvailable];
}

@end

NS_ASSUME_NONNULL_END
