//  SDLDeviceStatus.m
//

#import "SDLDeviceStatus.h"

#import "SDLDeviceLevelStatus.h"

#import "SDLPrimaryAudioSource.h"


@implementation SDLDeviceStatus

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setVoiceRecOn:(NSNumber *)voiceRecOn {
    if (voiceRecOn != nil) {
        [store setObject:voiceRecOn forKey:SDLNameVoiceRecOn];
    } else {
        [store removeObjectForKey:SDLNameVoiceRecOn];
    }
}

- (NSNumber *)voiceRecOn {
    return [store objectForKey:SDLNameVoiceRecOn];
}

- (void)setBtIconOn:(NSNumber *)btIconOn {
    if (btIconOn != nil) {
        [store setObject:btIconOn forKey:SDLNameBluetoothIconOn];
    } else {
        [store removeObjectForKey:SDLNameBluetoothIconOn];
    }
}

- (NSNumber *)btIconOn {
    return [store objectForKey:SDLNameBluetoothIconOn];
}

- (void)setCallActive:(NSNumber *)callActive {
    if (callActive != nil) {
        [store setObject:callActive forKey:SDLNameCallActive];
    } else {
        [store removeObjectForKey:SDLNameCallActive];
    }
}

- (NSNumber *)callActive {
    return [store objectForKey:SDLNameCallActive];
}

- (void)setPhoneRoaming:(NSNumber *)phoneRoaming {
    if (phoneRoaming != nil) {
        [store setObject:phoneRoaming forKey:SDLNamePhoneRoaming];
    } else {
        [store removeObjectForKey:SDLNamePhoneRoaming];
    }
}

- (NSNumber *)phoneRoaming {
    return [store objectForKey:SDLNamePhoneRoaming];
}

- (void)setTextMsgAvailable:(NSNumber *)textMsgAvailable {
    if (textMsgAvailable != nil) {
        [store setObject:textMsgAvailable forKey:SDLNameTextMsgAvailable];
    } else {
        [store removeObjectForKey:SDLNameTextMsgAvailable];
    }
}

- (NSNumber *)textMsgAvailable {
    return [store objectForKey:SDLNameTextMsgAvailable];
}

- (void)setBattLevelStatus:(SDLDeviceLevelStatus *)battLevelStatus {
    if (battLevelStatus != nil) {
        [store setObject:battLevelStatus forKey:SDLNameBattLevelStatus];
    } else {
        [store removeObjectForKey:SDLNameBattLevelStatus];
    }
}

- (SDLDeviceLevelStatus *)battLevelStatus {
    NSObject *obj = [store objectForKey:SDLNameBattLevelStatus];
    if (obj == nil || [obj isKindOfClass:SDLDeviceLevelStatus.class]) {
        return (SDLDeviceLevelStatus *)obj;
    } else {
        return [SDLDeviceLevelStatus valueOf:(NSString *)obj];
    }
}

- (void)setStereoAudioOutputMuted:(NSNumber *)stereoAudioOutputMuted {
    if (stereoAudioOutputMuted != nil) {
        [store setObject:stereoAudioOutputMuted forKey:SDLNameStereoAudioOutputMuted];
    } else {
        [store removeObjectForKey:SDLNameStereoAudioOutputMuted];
    }
}

- (NSNumber *)stereoAudioOutputMuted {
    return [store objectForKey:SDLNameStereoAudioOutputMuted];
}

- (void)setMonoAudioOutputMuted:(NSNumber *)monoAudioOutputMuted {
    if (monoAudioOutputMuted != nil) {
        [store setObject:monoAudioOutputMuted forKey:SDLNameMonoAudioOutputMuted];
    } else {
        [store removeObjectForKey:SDLNameMonoAudioOutputMuted];
    }
}

- (NSNumber *)monoAudioOutputMuted {
    return [store objectForKey:SDLNameMonoAudioOutputMuted];
}

- (void)setSignalLevelStatus:(SDLDeviceLevelStatus *)signalLevelStatus {
    if (signalLevelStatus != nil) {
        [store setObject:signalLevelStatus forKey:SDLNameSignalLevelStatus];
    } else {
        [store removeObjectForKey:SDLNameSignalLevelStatus];
    }
}

- (SDLDeviceLevelStatus *)signalLevelStatus {
    NSObject *obj = [store objectForKey:SDLNameSignalLevelStatus];
    if (obj == nil || [obj isKindOfClass:SDLDeviceLevelStatus.class]) {
        return (SDLDeviceLevelStatus *)obj;
    } else {
        return [SDLDeviceLevelStatus valueOf:(NSString *)obj];
    }
}

- (void)setPrimaryAudioSource:(SDLPrimaryAudioSource *)primaryAudioSource {
    if (primaryAudioSource != nil) {
        [store setObject:primaryAudioSource forKey:SDLNamePrimaryAudioSource];
    } else {
        [store removeObjectForKey:SDLNamePrimaryAudioSource];
    }
}

- (SDLPrimaryAudioSource *)primaryAudioSource {
    NSObject *obj = [store objectForKey:SDLNamePrimaryAudioSource];
    if (obj == nil || [obj isKindOfClass:SDLPrimaryAudioSource.class]) {
        return (SDLPrimaryAudioSource *)obj;
    } else {
        return [SDLPrimaryAudioSource valueOf:(NSString *)obj];
    }
}

- (void)setECallEventActive:(NSNumber *)eCallEventActive {
    if (eCallEventActive != nil) {
        [store setObject:eCallEventActive forKey:SDLNameECallEventActive];
    } else {
        [store removeObjectForKey:SDLNameECallEventActive];
    }
}

- (NSNumber *)eCallEventActive {
    return [store objectForKey:SDLNameECallEventActive];
}

@end
