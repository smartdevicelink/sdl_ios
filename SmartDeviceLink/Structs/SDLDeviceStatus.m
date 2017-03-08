//  SDLDeviceStatus.m
//

#import "SDLDeviceStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDeviceLevelStatus.h"
#import "SDLNames.h"
#import "SDLPrimaryAudioSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeviceStatus

- (void)setVoiceRecOn:(NSNumber<SDLBool> *)voiceRecOn {
    [store sdl_setObject:voiceRecOn forName:SDLNameVoiceRecognitionOn];
}

- (NSNumber<SDLBool> *)voiceRecOn {
    return [store sdl_objectForName:SDLNameVoiceRecognitionOn];
}

- (void)setBtIconOn:(NSNumber<SDLBool> *)btIconOn {
    [store sdl_setObject:btIconOn forName:SDLNameBluetoothIconOn];
}

- (NSNumber<SDLBool> *)btIconOn {
    return [store sdl_objectForName:SDLNameBluetoothIconOn];
}

- (void)setCallActive:(NSNumber<SDLBool> *)callActive {
    [store sdl_setObject:callActive forName:SDLNameCallActive];
}

- (NSNumber<SDLBool> *)callActive {
    return [store sdl_objectForName:SDLNameCallActive];
}

- (void)setPhoneRoaming:(NSNumber<SDLBool> *)phoneRoaming {
    [store sdl_setObject:phoneRoaming forName:SDLNamePhoneRoaming];
}

- (NSNumber<SDLBool> *)phoneRoaming {
    return [store sdl_objectForName:SDLNamePhoneRoaming];
}

- (void)setTextMsgAvailable:(NSNumber<SDLBool> *)textMsgAvailable {
    [store sdl_setObject:textMsgAvailable forName:SDLNameTextMessageAvailable];
}

- (NSNumber<SDLBool> *)textMsgAvailable {
    return [store sdl_objectForName:SDLNameTextMessageAvailable];
}

- (void)setBattLevelStatus:(SDLDeviceLevelStatus )battLevelStatus {
    [store sdl_setObject:battLevelStatus forName:SDLNameBatteryLevelStatus];
}

- (SDLDeviceLevelStatus)battLevelStatus {
    return [store sdl_objectForName:SDLNameBatteryLevelStatus];
}

- (void)setStereoAudioOutputMuted:(NSNumber<SDLBool> *)stereoAudioOutputMuted {
    [store sdl_setObject:stereoAudioOutputMuted forName:SDLNameStereoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)stereoAudioOutputMuted {
    return [store sdl_objectForName:SDLNameStereoAudioOutputMuted];
}

- (void)setMonoAudioOutputMuted:(NSNumber<SDLBool> *)monoAudioOutputMuted {
    [store sdl_setObject:monoAudioOutputMuted forName:SDLNameMonoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)monoAudioOutputMuted {
    return [store sdl_objectForName:SDLNameMonoAudioOutputMuted];
}

- (void)setSignalLevelStatus:(SDLDeviceLevelStatus)signalLevelStatus {
    [store sdl_setObject:signalLevelStatus forName:SDLNameSignalLevelStatus];
}

- (SDLDeviceLevelStatus)signalLevelStatus {
    return [store sdl_objectForName:SDLNameSignalLevelStatus];
}

- (void)setPrimaryAudioSource:(SDLPrimaryAudioSource)primaryAudioSource {
    [store sdl_setObject:primaryAudioSource forName:SDLNamePrimaryAudioSource];
}

- (SDLPrimaryAudioSource)primaryAudioSource {
    return [store sdl_objectForName:SDLNamePrimaryAudioSource];
}

- (void)setECallEventActive:(NSNumber<SDLBool> *)eCallEventActive {
    [store sdl_setObject:eCallEventActive forName:SDLNameECallEventActive];
}

- (NSNumber<SDLBool> *)eCallEventActive {
    return [store sdl_objectForName:SDLNameECallEventActive];
}

@end

NS_ASSUME_NONNULL_END
