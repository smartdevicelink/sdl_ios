//  SDLRegisterAppInterfaceResponse.m
//


#import "SDLRegisterAppInterfaceResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLHMICapabilities.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSyncMsgVersion.h"
#import "SDLVehicleType.h"
#import "SDLVrCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRegisterAppInterfaceResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameRegisterAppInterface]) {
    }
    return self;
}

- (void)setSyncMsgVersion:(nullable SDLSyncMsgVersion *)syncMsgVersion {
    [parameters sdl_setObject:syncMsgVersion forName:SDLRPCParameterNameSyncMessageVersion];
}

- (nullable SDLSyncMsgVersion *)syncMsgVersion {
    return [parameters sdl_objectForName:SDLRPCParameterNameSyncMessageVersion ofClass:SDLSyncMsgVersion.class error:nil];
}

- (void)setLanguage:(nullable SDLLanguage)language {
    [parameters sdl_setObject:language forName:SDLRPCParameterNameLanguage];
}

- (nullable SDLLanguage)language {
    return [parameters sdl_enumForName:SDLRPCParameterNameLanguage error:nil];
}

- (void)setHmiDisplayLanguage:(nullable SDLLanguage)hmiDisplayLanguage {
    [parameters sdl_setObject:hmiDisplayLanguage forName:SDLRPCParameterNameHMIDisplayLanguage];
}

- (nullable SDLLanguage)hmiDisplayLanguage {
    return [parameters sdl_enumForName:SDLRPCParameterNameHMIDisplayLanguage error:nil];
}

- (void)setDisplayCapabilities:(nullable SDLDisplayCapabilities *)displayCapabilities {
    [parameters sdl_setObject:displayCapabilities forName:SDLRPCParameterNameDisplayCapabilities];
}

- (nullable SDLDisplayCapabilities *)displayCapabilities {
    return [parameters sdl_objectForName:SDLRPCParameterNameDisplayCapabilities ofClass:SDLDisplayCapabilities.class error:nil];
}

- (void)setButtonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [parameters sdl_setObject:buttonCapabilities forName:SDLRPCParameterNameButtonCapabilities];
}

- (nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [parameters sdl_objectsForName:SDLRPCParameterNameButtonCapabilities ofClass:SDLButtonCapabilities.class error:nil];
}

- (void)setSoftButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [parameters sdl_setObject:softButtonCapabilities forName:SDLRPCParameterNameSoftButtonCapabilities];
}

- (nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    return [parameters sdl_objectsForName:SDLRPCParameterNameSoftButtonCapabilities ofClass:SDLSoftButtonCapabilities.class error:nil];
}

- (void)setPresetBankCapabilities:(nullable SDLPresetBankCapabilities *)presetBankCapabilities {
    [parameters sdl_setObject:presetBankCapabilities forName:SDLRPCParameterNamePresetBankCapabilities];
}

- (nullable SDLPresetBankCapabilities *)presetBankCapabilities {
    return [parameters sdl_objectForName:SDLRPCParameterNamePresetBankCapabilities ofClass:SDLPresetBankCapabilities.class error:nil];
}

- (void)setHmiZoneCapabilities:(nullable NSArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    [parameters sdl_setObject:hmiZoneCapabilities forName:SDLRPCParameterNameHMIZoneCapabilities];
}

- (nullable NSArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    return [parameters sdl_enumsForName:SDLRPCParameterNameHMIZoneCapabilities error:nil];
}

- (void)setSpeechCapabilities:(nullable NSArray<SDLSpeechCapabilities> *)speechCapabilities {
    [parameters sdl_setObject:speechCapabilities forName:SDLRPCParameterNameSpeechCapabilities];
}

- (nullable NSArray<SDLSpeechCapabilities> *)speechCapabilities {
    return [parameters sdl_enumsForName:SDLRPCParameterNameSpeechCapabilities error:nil];
}

- (void)setPrerecordedSpeech:(nullable NSArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    [parameters sdl_setObject:prerecordedSpeech forName:SDLRPCParameterNamePrerecordedSpeech];
}

- (nullable NSArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    return [parameters sdl_enumsForName:SDLRPCParameterNamePrerecordedSpeech error:nil];
}

- (void)setVrCapabilities:(nullable NSArray<SDLVRCapabilities> *)vrCapabilities {
    [parameters sdl_setObject:vrCapabilities forName:SDLRPCParameterNameVRCapabilities];
}

- (nullable NSArray<SDLVRCapabilities> *)vrCapabilities {
    return [parameters sdl_enumsForName:SDLRPCParameterNameVRCapabilities error:nil];
}

- (void)setAudioPassThruCapabilities:(nullable NSArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    [parameters sdl_setObject:audioPassThruCapabilities forName:SDLRPCParameterNameAudioPassThruCapabilities];
}

- (nullable NSArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    return [parameters sdl_objectsForName:SDLRPCParameterNameAudioPassThruCapabilities ofClass:SDLAudioPassThruCapabilities.class error:nil];
}

- (void)setPcmStreamCapabilities:(nullable SDLAudioPassThruCapabilities *)pcmStreamCapabilities {
    [parameters sdl_setObject:pcmStreamCapabilities forName:SDLRPCParameterNamePCMStreamCapabilities];
}

- (nullable SDLAudioPassThruCapabilities *)pcmStreamCapabilities {
    return [parameters sdl_objectForName:SDLRPCParameterNamePCMStreamCapabilities ofClass:SDLAudioPassThruCapabilities.class error:nil];
}

- (void)setVehicleType:(nullable SDLVehicleType *)vehicleType {
    [parameters sdl_setObject:vehicleType forName:SDLRPCParameterNameVehicleType];
}

- (nullable SDLVehicleType *)vehicleType {
    return [parameters sdl_objectForName:SDLRPCParameterNameVehicleType ofClass:SDLVehicleType.class error:nil];
}

- (void)setSupportedDiagModes:(nullable NSArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    [parameters sdl_setObject:supportedDiagModes forName:SDLRPCParameterNameSupportedDiagnosticModes];
}

- (nullable NSArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    return [parameters sdl_objectsForName:SDLRPCParameterNameSupportedDiagnosticModes ofClass:NSNumber.class error:nil];
}

- (void)setHmiCapabilities:(nullable SDLHMICapabilities *)hmiCapabilities {
    [parameters sdl_setObject:hmiCapabilities forName:SDLRPCParameterNameHMICapabilities];
}

- (nullable SDLHMICapabilities *)hmiCapabilities {
    return [parameters sdl_objectForName:SDLRPCParameterNameHMICapabilities ofClass:SDLHMICapabilities.class error:nil];
}

- (void)setSdlVersion:(nullable NSString *)sdlVersion {
    [parameters sdl_setObject:sdlVersion forName:SDLRPCParameterNameSDLVersion];
}

- (nullable NSString *)sdlVersion {
    return [parameters sdl_objectForName:SDLRPCParameterNameSDLVersion ofClass:NSString.class error:nil];
}

- (void)setSystemSoftwareVersion:(nullable NSString *)systemSoftwareVersion {
    [parameters sdl_setObject:systemSoftwareVersion forName:SDLRPCParameterNameSystemSoftwareVersion];
}

- (nullable NSString *)systemSoftwareVersion {
    return [parameters sdl_objectForName:SDLRPCParameterNameSystemSoftwareVersion ofClass:NSString.class error:nil];
}

- (void)setIconResumed:(nullable NSNumber<SDLBool> *)iconResumed {
    [parameters sdl_setObject:iconResumed forName:SDLRPCParameterNameIconResumed];
}

- (nullable NSNumber<SDLBool> *)iconResumed {
    return [parameters sdl_objectForName:SDLRPCParameterNameIconResumed ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
