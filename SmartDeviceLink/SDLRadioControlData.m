//
//  SDLRadioControlData.m
//

#import "SDLRadioControlData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRDSData.h"
#import "SDLSISData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRadioControlData

- (instancetype)initWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction band:(nullable SDLRadioBand)band hdChannel:(nullable NSNumber<SDLInt> *)hdChannel radioEnable:(nullable NSNumber<SDLBool> *)radioEnable {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.frequencyInteger = frequencyInteger;
    self.frequencyFraction = frequencyFraction;
    self.band = band;
    self.hdChannel = hdChannel;
    self.radioEnable = radioEnable;
    
    return self;
}

- (instancetype)initWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction band:(nullable SDLRadioBand)band hdChannel:(nullable NSNumber<SDLInt> *)hdChannel radioEnable:(nullable NSNumber<SDLBool> *)radioEnable hdRadioEnable:(nullable NSNumber<SDLBool> *)hdRadioEnable {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.frequencyInteger = frequencyInteger;
    self.frequencyFraction = frequencyFraction;
    self.band = band;
    self.hdChannel = hdChannel;
    self.radioEnable = radioEnable;
    self.hdRadioEnable = hdRadioEnable;
    
    return self;
}

- (void)setFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger {
    [store sdl_setObject:frequencyInteger forName:SDLRPCParameterNameFrequencyInteger];
}

- (nullable NSNumber<SDLInt> *)frequencyInteger {
    return [store sdl_objectForName:SDLRPCParameterNameFrequencyInteger ofClass:NSNumber.class error:nil];
}

- (void)setFrequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction {
    [store sdl_setObject:frequencyFraction forName:SDLRPCParameterNameFrequencyFraction];
}

- (nullable NSNumber<SDLInt> *)frequencyFraction {
    return [store sdl_objectForName:SDLRPCParameterNameFrequencyFraction ofClass:NSNumber.class error:nil];
}

- (void)setBand:(nullable SDLRadioBand)band {
    [store sdl_setObject:band forName:SDLRPCParameterNameBand];
}

- (nullable SDLRadioBand)band{
    return [store sdl_enumForName:SDLRPCParameterNameBand error:nil];
}

- (void)setRdsData:(nullable SDLRDSData *)rdsData {
    [store sdl_setObject:rdsData forName:SDLRPCParameterNameRDSData];
}

- (nullable SDLRDSData *)rdsData {
    return [store sdl_objectForName:SDLRPCParameterNameRDSData ofClass:SDLRDSData.class error:nil];
}

- (void)setAvailableHDs:(nullable NSNumber<SDLInt> *)availableHDs {
    [store sdl_setObject:availableHDs forName:SDLRPCParameterNameAvailableHDs];
}

- (nullable NSNumber<SDLInt> *)availableHDs {
    return [store sdl_objectForName:SDLRPCParameterNameAvailableHDs ofClass:NSNumber.class error:nil];
}

- (void)setHdChannel:(nullable NSNumber<SDLInt> *)hdChannel {
    [store sdl_setObject:hdChannel forName:SDLRPCParameterNameHDChannel];
}

- (nullable NSNumber<SDLInt> *)hdChannel {
    return [store sdl_objectForName:SDLRPCParameterNameHDChannel ofClass:NSNumber.class error:nil];
}

- (void)setSignalStrength:(nullable NSNumber<SDLInt> *)signalStrength {
    [store sdl_setObject:signalStrength forName:SDLRPCParameterNameSignalStrength];
}

- (nullable NSNumber<SDLInt> *)signalStrength {
    return [store sdl_objectForName:SDLRPCParameterNameSignalStrength ofClass:NSNumber.class error:nil];
}

- (void)setSignalChangeThreshold:(nullable NSNumber<SDLInt> *)signalChangeThreshold {
    [store sdl_setObject:signalChangeThreshold forName:SDLRPCParameterNameSignalChangeThreshold];
}

- (nullable NSNumber<SDLInt> *)signalChangeThreshold {
    return [store sdl_objectForName:SDLRPCParameterNameSignalChangeThreshold ofClass:NSNumber.class error:nil];
}

- (void)setRadioEnable:(nullable NSNumber<SDLBool> *)radioEnable {
    [store sdl_setObject:radioEnable forName:SDLRPCParameterNameRadioEnable];
}

- (nullable NSNumber<SDLBool> *)radioEnable {
    return [store sdl_objectForName:SDLRPCParameterNameRadioEnable ofClass:NSNumber.class error:nil];
}

- (void)setState:(nullable SDLRadioState)state {
    [store sdl_setObject:state forName:SDLRPCParameterNameState];
}

- (nullable SDLRadioState)state {
    return [store sdl_enumForName:SDLRPCParameterNameState error:nil];
}

- (void)setHdRadioEnable:(nullable NSNumber<SDLBool> *)hdRadioEnable {
    [store sdl_setObject:hdRadioEnable forName:SDLRPCParameterNameHDRadioEnable];
}

- (nullable NSNumber<SDLBool> *)hdRadioEnable {
    return [store sdl_objectForName:SDLRPCParameterNameHDRadioEnable ofClass:NSNumber.class error:nil];
}

- (void)setSisData:(nullable SDLSISData *)sisData {
    [store sdl_setObject:sisData forName:SDLRPCParameterNameSISData];
}

- (nullable SDLSISData *)sisData {
    return [store sdl_objectForName:SDLRPCParameterNameSISData ofClass:SDLSISData.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
