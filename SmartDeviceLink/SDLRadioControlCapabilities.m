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

-(instancetype) initWithModuleName: (NSString *) moduleName {
    self = [self init];
    
    self.moduleName = moduleName;
    
    return self;
}

-(instancetype) initWithRadioEnableAvailable:(NSNumber<SDLBool> *)radioEnableAvailable {
    self = [self init];
    
    self.radioEnableAvailable = radioEnableAvailable;
    
    return self;
}

-(instancetype) initWithRadioBandAvailable:(NSNumber<SDLBool> *)radioBandAvailable {
    self = [self init];
    
    self.radioBandAvailable = radioBandAvailable;
    
    return self;
}

-(instancetype) initWithRadioFrequencyAvailable:(NSNumber<SDLBool> *)radioFrequencyAvailable {
    self = [self init];
    
    self.radioFrequencyAvailable = radioFrequencyAvailable;
    
    return self;
}

-(instancetype) initWithHDChannelAvailable:(NSNumber<SDLBool> *)hdChannelAvailable {
    self = [self init];
    
    self.hdChannelAvailable = hdChannelAvailable;
    
    return self;
}

-(instancetype) initWithRdsDataAvailable:(NSNumber<SDLBool> *)rdsDataAvailable {
    self = [self init];
    
    self.rdsDataAvailable = rdsDataAvailable;
    
    return self;
}

-(instancetype) initWithAvailableHDsAvailable:(NSNumber<SDLBool> *)availableHDsAvailable {
    self = [self init];
    
    self.availableHDsAvailable = availableHDsAvailable;
    
    return self;
}

-(instancetype) initWithStateAvailable:(NSNumber<SDLBool> *)stateAvailable {
    self = [self init];
    
    self.stateAvailable = stateAvailable;
    
    return self;
}

-(instancetype) initWithSignalStrengthAvailable:(NSNumber<SDLBool> *)signalStrengthAvailable {
    self = [self init];
    
    self.signalStrengthAvailable = signalStrengthAvailable;
    
    return self;
}

-(instancetype) initWithSignalChangeThresholdAvailable:(NSNumber<SDLBool> *)signalChangeThresholdAvailable {
    self = [self init];
    
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
