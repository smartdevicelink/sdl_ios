//  SDLRegisterAppInterfaceResponse.m
//


#import "SDLRegisterAppInterfaceResponse.h"

#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLHMICapabilities.h"
#import "SDLNames.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSyncMsgVersion.h"
#import "SDLVehicleType.h"

@implementation SDLRegisterAppInterfaceResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameRegisterAppInterface]) {
    }
    return self;
}

- (void)setSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    [parameters sdl_setObject:syncMsgVersion forName:SDLNameSyncMessageVersion];
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    return [parameters sdl_objectForName:SDLNameSyncMessageVersion ofClass:SDLSyncMsgVersion.class];
}

- (void)setLanguage:(SDLLanguage)language {
    [parameters sdl_setObject:language forName:SDLNameLanguage];
}

- (SDLLanguage)language {
    return [parameters sdl_objectForName:SDLNameLanguage];
}

- (void)setHmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    [parameters sdl_setObject:hmiDisplayLanguage forName:SDLNameHMIDisplayLanguage];
}

- (SDLLanguage)hmiDisplayLanguage {
    return [parameters sdl_objectForName:SDLNameHMIDisplayLanguage];
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    [parameters sdl_setObject:displayCapabilities forName:SDLNameDisplayCapabilities];
}

- (SDLDisplayCapabilities *)displayCapabilities {
    return [parameters sdl_objectForName:SDLNameDisplayCapabilities ofClass:SDLDisplayCapabilities.class];
}

- (void)setButtonCapabilities:(NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [parameters sdl_setObject:buttonCapabilities forName:SDLNameButtonCapabilities];
}

- (NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [parameters sdl_objectsForName:SDLNameButtonCapabilities ofClass:SDLButtonCapabilities.class];
}

- (void)setSoftButtonCapabilities:(NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [parameters sdl_setObject:softButtonCapabilities forName:SDLNameSoftButtonCapabilities];
}

- (NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    return [parameters sdl_objectsForName:SDLNameSoftButtonCapabilities ofClass:SDLSoftButtonCapabilities.class];
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    [parameters sdl_setObject:presetBankCapabilities forName:SDLNamePresetBankCapabilities];
}

- (SDLPresetBankCapabilities *)presetBankCapabilities {
    return [parameters sdl_objectForName:SDLNamePresetBankCapabilities ofClass:SDLPresetBankCapabilities.class];
}

- (void)setHmiZoneCapabilities:(NSMutableArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    [parameters sdl_setObject:hmiZoneCapabilities forName:SDLNameHMIZoneCapabilities];
}

- (NSMutableArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    return [parameters sdl_objectForName:SDLNameHMIZoneCapabilities];
}

- (void)setSpeechCapabilities:(NSMutableArray<SDLSpeechCapabilities> *)speechCapabilities {
    [parameters sdl_setObject:speechCapabilities forName:SDLNameSpeechCapabilities];
}

- (NSMutableArray<SDLSpeechCapabilities> *)speechCapabilities {
    return [parameters sdl_objectForName:SDLNameSpeechCapabilities];
}

- (void)setPrerecordedSpeech:(NSMutableArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    [parameters sdl_setObject:prerecordedSpeech forName:SDLNamePrerecordedSpeech];
}

- (NSMutableArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    return [parameters sdl_objectForName:SDLNamePrerecordedSpeech];
}

- (void)setVrCapabilities:(NSMutableArray<SDLVRCapabilities> *)vrCapabilities {
    [parameters sdl_setObject:vrCapabilities forName:SDLNameVRCapabilities];
}

- (NSMutableArray<SDLVRCapabilities> *)vrCapabilities {
    return [parameters sdl_objectForName:SDLNameVRCapabilities];
}

- (void)setAudioPassThruCapabilities:(NSMutableArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    [parameters sdl_setObject:audioPassThruCapabilities forName:SDLNameAudioPassThruCapabilities];
}

- (NSMutableArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    return [parameters sdl_objectsForName:SDLNameAudioPassThruCapabilities ofClass:SDLAudioPassThruCapabilities.class];
}

- (void)setVehicleType:(SDLVehicleType *)vehicleType {
    [parameters sdl_setObject:vehicleType forName:SDLNameVehicleType];
}

- (SDLVehicleType *)vehicleType {
    return [parameters sdl_objectForName:SDLNameVehicleType ofClass:SDLVehicleType.class];
}

- (void)setSupportedDiagModes:(NSMutableArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    [parameters sdl_setObject:supportedDiagModes forName:SDLNameSupportedDiagnosticModes];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    return [parameters sdl_objectForName:SDLNameSupportedDiagnosticModes];
}

- (void)setHmiCapabilities:(SDLHMICapabilities *)hmiCapabilities {
    [parameters sdl_setObject:hmiCapabilities forName:SDLNameHMICapabilities];
}

- (SDLHMICapabilities *)hmiCapabilities {
    return [parameters sdl_objectForName:SDLNameHMICapabilities ofClass:SDLHMICapabilities.class];
}

- (void)setSdlVersion:(NSString *)sdlVersion {
    [parameters sdl_setObject:sdlVersion forName:SDLNameSDLVersion];
}

- (NSString *)sdlVersion {
    return [parameters sdl_objectForName:SDLNameSDLVersion];
}

- (void)setSystemSoftwareVersion:(NSString *)systemSoftwareVersion {
    [parameters sdl_setObject:systemSoftwareVersion forName:SDLNameSystemSoftwareVersion];
}

- (NSString *)systemSoftwareVersion {
    return [parameters sdl_objectForName:SDLNameSystemSoftwareVersion];
}

@end
