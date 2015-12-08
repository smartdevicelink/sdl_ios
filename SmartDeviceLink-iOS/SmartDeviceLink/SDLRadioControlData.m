//
//  SDLRadioControlData.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRadioControlData.h"

#import "SDLNames.h"
#import "SDLRadioBand.h"
#import "SDLRadioState.h"
#import "SDLRDSData.h"


@implementation SDLRadioControlData

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

- (void)setFrequencyInteger:(NSNumber *)frequencyInteger {
    if (frequencyInteger != nil) {
        [store setObject:frequencyInteger forKey:NAMES_frequencyInteger];
    } else {
        [store removeObjectForKey:NAMES_frequencyInteger];
    }
}

- (NSNumber *)frequencyInteger {
    return [store objectForKey:NAMES_frequencyInteger];
}

- (void)setFrequencyFraction:(NSNumber *)frequencyFraction {
    if (frequencyFraction != nil) {
        [store setObject:frequencyFraction forKey:NAMES_frequencyFraction];
    } else {
        [store removeObjectForKey:NAMES_frequencyFraction];
    }
}

- (NSNumber *)frequencyFraction {
    return [store objectForKey:NAMES_frequencyFraction];
}

- (void)setBand:(SDLRadioBand *)band {
    if (band != nil) {
        [store setObject:band forKey:NAMES_band];
    } else {
        [store removeObjectForKey:NAMES_band];
    }
}

- (SDLRadioBand *)band {
    NSObject *obj = [store objectForKey:NAMES_band];
    if ([obj isKindOfClass:[SDLRadioBand class]]) {
        return (SDLRadioBand *)obj;
    } else {
        return [SDLRadioBand valueOf:(NSString *)obj];
    }
}

- (void)setRdsData:(SDLRDSData *)rdsData {
    if (rdsData != nil) {
        [store setObject:rdsData forKey:NAMES_rdsData];
    } else {
        [store removeObjectForKey:NAMES_rdsData];
    }
}

- (SDLRDSData *)rdsData {
    NSObject *obj = [store objectForKey:NAMES_rdsData];
    if ([obj isKindOfClass:[SDLRDSData class]]) {
        return (SDLRDSData *)obj;
    } else {
        return [[SDLRDSData alloc] initWithDictionary:[obj mutableCopy]];
    }
}

- (void)setAvailableHDChannels:(NSNumber *)availableHDChannels {
    if (availableHDChannels != nil) {
        [store setObject:availableHDChannels forKey:NAMES_availableHDs];
    } else {
        [store removeObjectForKey:NAMES_availableHDs];
    }
}

- (NSNumber *)availableHDChannels {
    return [store objectForKey:NAMES_availableHDs];
}

- (void)setCurrentHDChannel:(NSNumber *)currentHDChannel {
    if (currentHDChannel != nil) {
        [store setObject:currentHDChannel forKey:NAMES_hdChannel];
    } else {
        [store removeObjectForKey:NAMES_hdChannel];
    }
}

- (NSNumber *)currentHDChannel {
    return [store objectForKey:NAMES_hdChannel];
}

- (void)setSignalStrength:(NSNumber *)signalStrength {
    if (signalStrength != nil) {
        [store setObject:signalStrength forKey:NAMES_signalStrength];
    } else {
        [store removeObjectForKey:NAMES_signalStrength];
    }
}

- (NSNumber *)signalStrength {
    return [store objectForKey:NAMES_signalStrength];
}

- (void)setSignalChangeThreshold:(NSNumber *)signalChangeThreshold {
    if (signalChangeThreshold != nil) {
        [store setObject:signalChangeThreshold forKey:NAMES_signalChangeThreshold];
    } else {
        [store removeObjectForKey:NAMES_signalChangeThreshold];
    }
}

- (NSNumber *)signalChangeThreshold {
    return [store objectForKey:NAMES_signalChangeThreshold];
}

- (void)setRadioOn:(NSNumber *)radioOn {
    if (radioOn != nil) {
        [store setObject:radioOn forKey:NAMES_radioEnable];
    } else {
        [store removeObjectForKey:NAMES_radioEnable];
    }
}

- (NSNumber *)radioOn {
    return [store objectForKey:NAMES_radioEnable];
}

- (void)setRadioState:(SDLRadioState *)radioState {
    if (radioState != nil) {
        [store setObject:radioState forKey:NAMES_state];
    } else {
        [store removeObjectForKey:NAMES_state];
    }
}

- (SDLRadioState *)radioState {
    NSObject *obj = [store objectForKey:NAMES_state];
    if ([obj isKindOfClass:[SDLRadioState class]]) {
        return (SDLRadioState *)obj;
    } else {
        return [SDLRadioState valueOf:(NSString *)obj];
    }
}

@end
