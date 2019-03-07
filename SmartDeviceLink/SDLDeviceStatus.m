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
    NSError *error;
    return [store sdl_objectForName:SDLNameVoiceRecognitionOn ofClass:NSNumber.class error:&error];
}

- (void)setBtIconOn:(NSNumber<SDLBool> *)btIconOn {
    [store sdl_setObject:btIconOn forName:SDLNameBluetoothIconOn];
}

- (NSNumber<SDLBool> *)btIconOn {
    NSError *error;
    return [store sdl_objectForName:SDLNameBluetoothIconOn ofClass:NSNumber.class error:&error];
}

- (void)setCallActive:(NSNumber<SDLBool> *)callActive {
    [store sdl_setObject:callActive forName:SDLNameCallActive];
}

- (NSNumber<SDLBool> *)callActive {
    NSError *error;
    return [store sdl_objectForName:SDLNameCallActive ofClass:NSNumber.class error:&error];
}

- (void)setPhoneRoaming:(NSNumber<SDLBool> *)phoneRoaming {
    [store sdl_setObject:phoneRoaming forName:SDLNamePhoneRoaming];
}

- (NSNumber<SDLBool> *)phoneRoaming {
    NSError *error;
    return [store sdl_objectForName:SDLNamePhoneRoaming ofClass:NSNumber.class error:&error];
}

- (void)setTextMsgAvailable:(NSNumber<SDLBool> *)textMsgAvailable {
    [store sdl_setObject:textMsgAvailable forName:SDLNameTextMessageAvailable];
}

- (NSNumber<SDLBool> *)textMsgAvailable {
    NSError *error;
    return [store sdl_objectForName:SDLNameTextMessageAvailable ofClass:NSNumber.class error:&error];
}

- (void)setBattLevelStatus:(SDLDeviceLevelStatus )battLevelStatus {
    [store sdl_setObject:battLevelStatus forName:SDLNameBatteryLevelStatus];
}

- (SDLDeviceLevelStatus)battLevelStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNameBatteryLevelStatus error:&error];
}

- (void)setStereoAudioOutputMuted:(NSNumber<SDLBool> *)stereoAudioOutputMuted {
    [store sdl_setObject:stereoAudioOutputMuted forName:SDLNameStereoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)stereoAudioOutputMuted {
    NSError *error;
    return [store sdl_objectForName:SDLNameStereoAudioOutputMuted ofClass:NSNumber.class error:&error];
}

- (void)setMonoAudioOutputMuted:(NSNumber<SDLBool> *)monoAudioOutputMuted {
    [store sdl_setObject:monoAudioOutputMuted forName:SDLNameMonoAudioOutputMuted];
}

- (NSNumber<SDLBool> *)monoAudioOutputMuted {
    NSError *error;
    return [store sdl_objectForName:SDLNameMonoAudioOutputMuted ofClass:NSNumber.class error:&error];
}

- (void)setSignalLevelStatus:(SDLDeviceLevelStatus)signalLevelStatus {
    [store sdl_setObject:signalLevelStatus forName:SDLNameSignalLevelStatus];
}

- (SDLDeviceLevelStatus)signalLevelStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNameSignalLevelStatus error:&error];
}

- (void)setPrimaryAudioSource:(SDLPrimaryAudioSource)primaryAudioSource {
    [store sdl_setObject:primaryAudioSource forName:SDLNamePrimaryAudioSource];
}

- (SDLPrimaryAudioSource)primaryAudioSource {
    NSError *error;
    return [store sdl_enumForName:SDLNamePrimaryAudioSource error:&error];
}

- (void)setECallEventActive:(NSNumber<SDLBool> *)eCallEventActive {
    [store sdl_setObject:eCallEventActive forName:SDLNameECallEventActive];
}

- (NSNumber<SDLBool> *)eCallEventActive {
    NSError *error;
    return [store sdl_objectForName:SDLNameECallEventActive ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
