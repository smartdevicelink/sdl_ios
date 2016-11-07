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
    [self setObject:syncMsgVersion forName:SDLNameSyncMessageVersion];
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    return [self objectForName:SDLNameSyncMessageVersion ofClass:SDLSyncMsgVersion.class];
}

- (void)setLanguage:(SDLLanguage)language {
    [self setObject:language forName:SDLNameLanguage];
}

- (SDLLanguage)language {
    return [self objectForName:SDLNameLanguage];
}

- (void)setHmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    [self setObject:hmiDisplayLanguage forName:SDLNameHMIDisplayLanguage];
}

- (SDLLanguage)hmiDisplayLanguage {
    return [self objectForName:SDLNameHMIDisplayLanguage];
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    [self setObject:displayCapabilities forName:SDLNameDisplayCapabilities];
}

- (SDLDisplayCapabilities *)displayCapabilities {
    return [self objectForName:SDLNameDisplayCapabilities ofClass:SDLDisplayCapabilities.class];
}

- (void)setButtonCapabilities:(NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [self setObject:buttonCapabilities forName:SDLNameButtonCapabilities];
}

- (NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [self objectsForName:SDLNameButtonCapabilities ofClass:SDLButtonCapabilities.class];
}

- (void)setSoftButtonCapabilities:(NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [self setObject:softButtonCapabilities forName:SDLNameSoftButtonCapabilities];
}

- (NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    return [self objectsForName:SDLNameSoftButtonCapabilities ofClass:SDLSoftButtonCapabilities.class];
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    [self setObject:presetBankCapabilities forName:SDLNamePresetBankCapabilities];
}

- (SDLPresetBankCapabilities *)presetBankCapabilities {
    return [self objectForName:SDLNamePresetBankCapabilities ofClass:SDLPresetBankCapabilities.class];
}

- (void)setHmiZoneCapabilities:(NSMutableArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    [self setObject:hmiZoneCapabilities forName:SDLNameHMIZoneCapabilities];
}

- (NSMutableArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    return [self objectForName:SDLNameHMIZoneCapabilities];
}

- (void)setSpeechCapabilities:(NSMutableArray<SDLSpeechCapabilities> *)speechCapabilities {
    [self setObject:speechCapabilities forName:SDLNameSpeechCapabilities];
}

- (NSMutableArray<SDLSpeechCapabilities> *)speechCapabilities {
    return [self objectForName:SDLNameSpeechCapabilities];
}

- (void)setPrerecordedSpeech:(NSMutableArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    [self setObject:prerecordedSpeech forName:SDLNamePrerecordedSpeech];
}

- (NSMutableArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    return [self objectForName:SDLNamePrerecordedSpeech];
}

- (void)setVrCapabilities:(NSMutableArray<SDLVRCapabilities> *)vrCapabilities {
    [self setObject:vrCapabilities forName:SDLNameVRCapabilities];
}

- (NSMutableArray<SDLVRCapabilities> *)vrCapabilities {
    return [self objectForName:SDLNameVRCapabilities];
}

- (void)setAudioPassThruCapabilities:(NSMutableArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    [self setObject:audioPassThruCapabilities forName:SDLNameAudioPassThruCapabilities];
}

- (NSMutableArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    return [self objectsForName:SDLNameAudioPassThruCapabilities ofClass:SDLAudioPassThruCapabilities.class];
}

- (void)setVehicleType:(SDLVehicleType *)vehicleType {
    [self setObject:vehicleType forName:SDLNameVehicleType];
}

- (SDLVehicleType *)vehicleType {
    return [self objectForName:SDLNameVehicleType ofClass:SDLVehicleType.class];
}

- (void)setSupportedDiagModes:(NSMutableArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    [self setObject:supportedDiagModes forName:SDLNameSupportedDiagnosticModes];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    return [self objectForName:SDLNameSupportedDiagnosticModes];
}

- (void)setHmiCapabilities:(SDLHMICapabilities *)hmiCapabilities {
    [self setObject:hmiCapabilities forName:SDLNameHMICapabilities];
}

- (SDLHMICapabilities *)hmiCapabilities {
    return [self objectForName:SDLNameHMICapabilities ofClass:SDLHMICapabilities.class];
}

- (void)setSdlVersion:(NSString *)sdlVersion {
    [self setObject:sdlVersion forName:SDLNameSDLVersion];
}

- (NSString *)sdlVersion {
    return [self objectForName:SDLNameSDLVersion];
}

- (void)setSystemSoftwareVersion:(NSString *)systemSoftwareVersion {
    [self setObject:systemSoftwareVersion forName:SDLNameSystemSoftwareVersion];
}

- (NSString *)systemSoftwareVersion {
    return [self objectForName:SDLNameSystemSoftwareVersion];
}

@end
