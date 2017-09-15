//
//  SDLRadioControlData.m
//

#import "SDLRadioControlData.h"
#import "SDLNames.h"
#import "SDLRdsData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRadioControlData

- (instancetype)initWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction band:(nullable SDLRadioBand)band rdsData:(nullable SDLRdsData *)rdsData availableHDs:(nullable NSNumber<SDLInt> *)availableHDs hdChannel:(nullable NSNumber<SDLInt> *)hdChannel signalStrength:(nullable NSNumber<SDLInt> *)signalStrength signalChangeThreshold:(nullable NSNumber<SDLInt> *)signalChangeThreshold radioEnable:(nullable NSNumber<SDLBool> *)radioEnable state:(nullable SDLRadioState)state {
    self = [self init];
    if(!self){
        return nil;
    }

    self.frequencyInteger = frequencyInteger;
    self.frequencyFraction = frequencyFraction;
    self.band = band;
    self.rdsData = rdsData;
    self.availableHDs = availableHDs;
    self.hdChannel = hdChannel;
    self.signalStrength = signalStrength;
    self.signalChangeThreshold  = signalChangeThreshold;
    self.radioEnable = radioEnable;
    self.state = state;
    
    return self;
}

- (void)setFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger {
    [store sdl_setObject:frequencyInteger forName:SDLNameFrequencyInteger];
}

- (nullable NSNumber<SDLInt> *)frequencyInteger {
    return [store sdl_objectForName:SDLNameFrequencyInteger];
}

- (void)setFrequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction {
    [store sdl_setObject:frequencyFraction forName:SDLNameFrequencyFraction];
}

- (nullable NSNumber<SDLInt> *)frequencyFraction {
    return [store sdl_objectForName:SDLNameFrequencyFraction];
}

- (void)setBand:(nullable SDLRadioBand)band {
    [store sdl_setObject:band forName:SDLNameBand];
}

- (nullable SDLRadioBand)band{
    return [store sdl_objectForName:SDLNameBand];
}

- (void)setRdsData:(nullable SDLRdsData *)rdsData {
    [store sdl_setObject:rdsData forName:SDLNameRDSData];
}

- (nullable SDLRdsData *)rdsData {
    return [store sdl_objectForName:SDLNameRDSData ofClass:SDLRdsData.class];
}

- (void)setAvailableHDs:(nullable NSNumber<SDLInt> *)availableHDs {
    [store sdl_setObject:availableHDs forName:SDLNameAvailableHDs];
}

- (nullable NSNumber<SDLInt> *)availableHDs {
    return [store sdl_objectForName:SDLNameAvailableHDs];
}

- (void)setHdChannel:(nullable NSNumber<SDLInt> *)hdChannel {
    [store sdl_setObject:hdChannel forName:SDLNameHDChannel];
}

- (nullable NSNumber<SDLInt> *)hdChannel {
    return [store sdl_objectForName:SDLNameHDChannel];
}

- (void)setSignalStrength:(nullable NSNumber<SDLInt> *)signalStrength {
    [store sdl_setObject:signalStrength forName:SDLNameSignalStrength];
}

- (nullable NSNumber<SDLInt> *)signalStrength {
    return [store sdl_objectForName:SDLNameSignalStrength];
}

- (void)setSignalChangeThreshold:(nullable NSNumber<SDLInt> *)signalChangeThreshold {
    [store sdl_setObject:signalChangeThreshold forName:SDLNameSignalChangeThreshold];
}

- (nullable NSNumber<SDLInt> *)signalChangeThreshold {
    return [store sdl_objectForName:SDLNameSignalChangeThreshold];
}

- (void)setRadioEnable:(nullable NSNumber<SDLBool> *)radioEnable {
    [store sdl_setObject:radioEnable forName:SDLNameRadioEnable];
}

- (nullable NSNumber<SDLBool> *)radioEnable {
    return [store sdl_objectForName:SDLNameRadioEnable];
}

- (void)setState:(nullable SDLRadioState)state {
    [store sdl_setObject:state forName:SDLNameState];
}

- (nullable SDLRadioState)state {
    return [store sdl_objectForName:SDLNameState];
}

@end

NS_ASSUME_NONNULL_END
