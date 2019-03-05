//  SDLDeviceStatus.m
//

#import "SDLDeviceStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDeviceLevelStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLPrimaryAudioSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeviceStatus

- (void)setVoiceRecOn:(NSNumber<SDLBool> *)voiceRecOn {
    [store sdl_setObject:voiceRecOn forName:SDLRPCParameterNameVoiceRecognitionOn];
}

- (NSNumber<SDLBool> *)voiceRecOn {
    return [store sdl_objectForName:SDLRPCParameterNameVoiceRecognitionOn];
}

- (void)setBtIconOn:(NSNumber<SDLBool> *)btIconOn {
    [store sdl_setObject:btIconOn forName:SDLRPCParameterNameBluetoothIconOn];
}

- (NSNumber<SDLBool> *)btIconOn {
    return [store sdl_objectForName:SDLRPCParameterNameBluetoothIconOn];
}

- (void)setCallActive:(NSNumber<SDLBool> *)callActive {
    [store sdl_setObject:callActive forName:SDLRPCParameterNameCallActive];
}

- (NSNumber<SDLBool> *)callActive {
    return [store sdl_objectForName:SDLRPCParameterNameCallActive];
}

- (void)setPhoneRoaming:(NSNumber<SDLBool> *)phoneRoaming {
    [store sdl_setObject:phoneRoaming forName:SDLRPCParameterNamePhoneRoaming];
}

- (NSNumber<SDLBool> *)phoneRoaming {
    return [store sdl_objectForName:SDLRPCParameterNamePhoneRoaming];
}

- (void)setTextMsgAvailable:(NSNumber<SDLBool> *)textMsgAvailable {
    [store sdl_setObject:textMsgAvailable forName:SDLRPCParameterNameTextMessageAvailable];
}

- (NSNumber<SDLBool> *)textMsgAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameTextMessageAvailable];
}

- (void)setBattLevelStatus:(SDLDeviceLevelStatus )battLevelStatus {
    [store sdl_setObject:battLevelStatus forName:SDLRPCParameterNameBatteryLevelStatus];
}

- (SDLDeviceLevelStatus)battLevelStatus {
    return [store sdl_objectForName:SDLRPCParameterNameBatteryLevelStatus];
}

- (void)setStereoAudioOutputMuted:(NSNumber<SDLBool> *)stereoAudioOutputMuted {
    [store sdl_setObject:stereoAudioOutputMuted forName:SDLRPCParameterNameStereoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)stereoAudioOutputMuted {
    return [store sdl_objectForName:SDLRPCParameterNameStereoAudioOutputMuted];
}

- (void)setMonoAudioOutputMuted:(NSNumber<SDLBool> *)monoAudioOutputMuted {
    [store sdl_setObject:monoAudioOutputMuted forName:SDLRPCParameterNameMonoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)monoAudioOutputMuted {
    return [store sdl_objectForName:SDLRPCParameterNameMonoAudioOutputMuted];
}

- (void)setSignalLevelStatus:(SDLDeviceLevelStatus)signalLevelStatus {
    [store sdl_setObject:signalLevelStatus forName:SDLRPCParameterNameSignalLevelStatus];
}

- (SDLDeviceLevelStatus)signalLevelStatus {
    return [store sdl_objectForName:SDLRPCParameterNameSignalLevelStatus];
}

- (void)setPrimaryAudioSource:(SDLPrimaryAudioSource)primaryAudioSource {
    [store sdl_setObject:primaryAudioSource forName:SDLRPCParameterNamePrimaryAudioSource];
}

- (SDLPrimaryAudioSource)primaryAudioSource {
    return [store sdl_objectForName:SDLRPCParameterNamePrimaryAudioSource];
}

- (void)setECallEventActive:(NSNumber<SDLBool> *)eCallEventActive {
    [store sdl_setObject:eCallEventActive forName:SDLRPCParameterNameECallEventActive];
}

- (NSNumber<SDLBool> *)eCallEventActive {
    return [store sdl_objectForName:SDLRPCParameterNameECallEventActive];
}

@end

NS_ASSUME_NONNULL_END
