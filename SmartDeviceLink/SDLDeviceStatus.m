//  SDLDeviceStatus.m
//

#import "SDLDeviceStatus.h"

#import "SDLDeviceLevelStatus.h"
#import "SDLNames.h"
#import "SDLPrimaryAudioSource.h"

@implementation SDLDeviceStatus

- (void)setVoiceRecOn:(NSNumber<SDLBool> *)voiceRecOn {
    [self setObject:voiceRecOn forName:SDLNameVoiceRecognitionOn];
}

- (NSNumber<SDLBool> *)voiceRecOn {
    return [self objectForName:SDLNameVoiceRecognitionOn];
}

- (void)setBtIconOn:(NSNumber<SDLBool> *)btIconOn {
    [self setObject:btIconOn forName:SDLNameBluetoothIconOn];
}

- (NSNumber<SDLBool> *)btIconOn {
    return [self objectForName:SDLNameBluetoothIconOn];
}

- (void)setCallActive:(NSNumber<SDLBool> *)callActive {
    [self setObject:callActive forName:SDLNameCallActive];
}

- (NSNumber<SDLBool> *)callActive {
    return [self objectForName:SDLNameCallActive];
}

- (void)setPhoneRoaming:(NSNumber<SDLBool> *)phoneRoaming {
    [self setObject:phoneRoaming forName:SDLNamePhoneRoaming];
}

- (NSNumber<SDLBool> *)phoneRoaming {
    return [self objectForName:SDLNamePhoneRoaming];
}

- (void)setTextMsgAvailable:(NSNumber<SDLBool> *)textMsgAvailable {
    [self setObject:textMsgAvailable forName:SDLNameTextMessageAvailable];
}

- (NSNumber<SDLBool> *)textMsgAvailable {
    return [self objectForName:SDLNameTextMessageAvailable];
}

- (void)setBattLevelStatus:(SDLDeviceLevelStatus )battLevelStatus {
    [self setObject:battLevelStatus forName:SDLNameBatteryLevelStatus];
}

- (SDLDeviceLevelStatus)battLevelStatus {
    return [self objectForName:SDLNameBatteryLevelStatus];
}

- (void)setStereoAudioOutputMuted:(NSNumber<SDLBool> *)stereoAudioOutputMuted {
    [self setObject:stereoAudioOutputMuted forName:SDLNameStereoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)stereoAudioOutputMuted {
    return [self objectForName:SDLNameStereoAudioOutputMuted];
}

- (void)setMonoAudioOutputMuted:(NSNumber<SDLBool> *)monoAudioOutputMuted {
    [self setObject:monoAudioOutputMuted forName:SDLNameMonoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)monoAudioOutputMuted {
    return [self objectForName:SDLNameMonoAudioOutputMuted];
}

- (void)setSignalLevelStatus:(SDLDeviceLevelStatus)signalLevelStatus {
    [self setObject:signalLevelStatus forName:SDLNameSignalLevelStatus];
}

- (SDLDeviceLevelStatus)signalLevelStatus {
    return [self objectForName:SDLNameSignalLevelStatus];
}

- (void)setPrimaryAudioSource:(SDLPrimaryAudioSource)primaryAudioSource {
    [self setObject:primaryAudioSource forName:SDLNamePrimaryAudioSource];
}

- (SDLPrimaryAudioSource)primaryAudioSource {
    return [self objectForName:SDLNamePrimaryAudioSource];
}

- (void)setECallEventActive:(NSNumber<SDLBool> *)eCallEventActive {
    [self setObject:eCallEventActive forName:SDLNameECallEventActive];
}

- (NSNumber<SDLBool> *)eCallEventActive {
    return [self objectForName:SDLNameECallEventActive];
}

@end
