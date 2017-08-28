//
//  SDLRadioControlCapabilities.m
//

#import "SDLRadioControlCapabilities.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRadioControlCapabilities

-(instancetype) init {
    self = [super init];
    
    if(!self){
        return nil;
    }
    
    return self;
}

-(instancetype) initWithModuleName: (NSString *) moduleName radioEnableAvailable:(NSNumber<SDLBool> *)radioEnableAvailable radioBandAvailable:(NSNumber<SDLBool> *)radioBandAvailable radioFrequencyAvailable:(NSNumber<SDLBool> *)radioFrequencyAvailable hdChannelAvailable:(NSNumber<SDLBool> *)hdChannelAvailable rdsDataAvailable:(NSNumber<SDLBool> *)rdsDataAvailable availableHDsAvailable:(NSNumber<SDLBool> *)availableHDsAvailable stateAvailable:(NSNumber<SDLBool> *)stateAvailable signalStrengthAvailable:(NSNumber<SDLBool> *)signalStrengthAvailable signalChangeThresholdAvailable:(NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    self = [self init];
    
    self.moduleName = moduleName;
    self.radioEnableAvailable = radioEnableAvailable;
    self.radioBandAvailable = radioBandAvailable;
    self.radioFrequencyAvailable = radioFrequencyAvailable;
    self.hdChannelAvailable = hdChannelAvailable;
    self.rdsDataAvailable = rdsDataAvailable;
    self.availableHDsAvailable = availableHDsAvailable;
    self.stateAvailable = stateAvailable;
    self.signalStrengthAvailable = signalStrengthAvailable;
    self.signalChangeThresholdAvailable = signalChangeThresholdAvailable;
    
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
    [store sdl_setObject:hdChannelAvailable forName:SDLNameHdChannelAvailable];
    
}

- (nullable NSNumber<SDLBool> *)hdChannelAvailable {
    return [store sdl_objectForName:SDLNameHdChannelAvailable];
}

- (void)setRdsDataAvailable:(nullable NSNumber<SDLBool> *)rdsDataAvailable {
    [store sdl_setObject:rdsDataAvailable forName:SDLNameRdsDataAvailable];
    
}

- (nullable NSNumber<SDLBool> *)rdsDataAvailable {
    return [store sdl_objectForName:SDLNameRdsDataAvailable];
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

@end

NS_ASSUME_NONNULL_END
