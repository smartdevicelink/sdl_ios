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
#import "SDLMsgVersion.h"
#import "SDLVehicleType.h"
#import "SDLVrCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRegisterAppInterfaceResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameRegisterAppInterface]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setSdlMsgVersion:(nullable SDLMsgVersion *)sdlMsgVersion {
    [self.parameters sdl_setObject:sdlMsgVersion forName:SDLRPCParameterNameSyncMessageVersion];
}

- (nullable SDLMsgVersion *)sdlMsgVersion {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSyncMessageVersion ofClass:SDLMsgVersion.class error:nil];
}

- (void)setLanguage:(nullable SDLLanguage)language {
    [self.parameters sdl_setObject:language forName:SDLRPCParameterNameLanguage];
}

- (nullable SDLLanguage)language {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameLanguage error:nil];
}

- (void)setHmiDisplayLanguage:(nullable SDLLanguage)hmiDisplayLanguage {
    [self.parameters sdl_setObject:hmiDisplayLanguage forName:SDLRPCParameterNameHMIDisplayLanguage];
}

- (nullable SDLLanguage)hmiDisplayLanguage {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameHMIDisplayLanguage error:nil];
}

- (void)setDisplayCapabilities:(nullable SDLDisplayCapabilities *)displayCapabilities {
    [self.parameters sdl_setObject:displayCapabilities forName:SDLRPCParameterNameDisplayCapabilities];
}

- (nullable SDLDisplayCapabilities *)displayCapabilities {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDisplayCapabilities ofClass:SDLDisplayCapabilities.class error:nil];
}

- (void)setButtonCapabilities:(nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    [self.parameters sdl_setObject:buttonCapabilities forName:SDLRPCParameterNameButtonCapabilities];
}

- (nullable NSArray<SDLButtonCapabilities *> *)buttonCapabilities {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameButtonCapabilities ofClass:SDLButtonCapabilities.class error:nil];
}

- (void)setSoftButtonCapabilities:(nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    [self.parameters sdl_setObject:softButtonCapabilities forName:SDLRPCParameterNameSoftButtonCapabilities];
}

- (nullable NSArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameSoftButtonCapabilities ofClass:SDLSoftButtonCapabilities.class error:nil];
}

- (void)setPresetBankCapabilities:(nullable SDLPresetBankCapabilities *)presetBankCapabilities {
    [self.parameters sdl_setObject:presetBankCapabilities forName:SDLRPCParameterNamePresetBankCapabilities];
}

- (nullable SDLPresetBankCapabilities *)presetBankCapabilities {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePresetBankCapabilities ofClass:SDLPresetBankCapabilities.class error:nil];
}

- (void)setHmiZoneCapabilities:(nullable NSArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    [self.parameters sdl_setObject:hmiZoneCapabilities forName:SDLRPCParameterNameHMIZoneCapabilities];
}

- (nullable NSArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    return [self.parameters sdl_enumsForName:SDLRPCParameterNameHMIZoneCapabilities error:nil];
}

- (void)setSpeechCapabilities:(nullable NSArray<SDLSpeechCapabilities> *)speechCapabilities {
    [self.parameters sdl_setObject:speechCapabilities forName:SDLRPCParameterNameSpeechCapabilities];
}

- (nullable NSArray<SDLSpeechCapabilities> *)speechCapabilities {
    return [self.parameters sdl_enumsForName:SDLRPCParameterNameSpeechCapabilities error:nil];
}

- (void)setPrerecordedSpeech:(nullable NSArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    [self.parameters sdl_setObject:prerecordedSpeech forName:SDLRPCParameterNamePrerecordedSpeech];
}

- (nullable NSArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    return [self.parameters sdl_enumsForName:SDLRPCParameterNamePrerecordedSpeech error:nil];
}

- (void)setVrCapabilities:(nullable NSArray<SDLVRCapabilities> *)vrCapabilities {
    [self.parameters sdl_setObject:vrCapabilities forName:SDLRPCParameterNameVRCapabilities];
}

- (nullable NSArray<SDLVRCapabilities> *)vrCapabilities {
    return [self.parameters sdl_enumsForName:SDLRPCParameterNameVRCapabilities error:nil];
}

- (void)setAudioPassThruCapabilities:(nullable NSArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    [self.parameters sdl_setObject:audioPassThruCapabilities forName:SDLRPCParameterNameAudioPassThruCapabilities];
}

- (nullable NSArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameAudioPassThruCapabilities ofClass:SDLAudioPassThruCapabilities.class error:nil];
}

- (void)setPcmStreamCapabilities:(nullable SDLAudioPassThruCapabilities *)pcmStreamCapabilities {
    [self.parameters sdl_setObject:pcmStreamCapabilities forName:SDLRPCParameterNamePCMStreamCapabilities];
}

- (nullable SDLAudioPassThruCapabilities *)pcmStreamCapabilities {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePCMStreamCapabilities ofClass:SDLAudioPassThruCapabilities.class error:nil];
}

- (void)setVehicleType:(nullable SDLVehicleType *)vehicleType {
    [self.parameters sdl_setObject:vehicleType forName:SDLRPCParameterNameVehicleType];
}

- (nullable SDLVehicleType *)vehicleType {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameVehicleType ofClass:SDLVehicleType.class error:nil];
}

- (void)setSupportedDiagModes:(nullable NSArray<NSNumber *> *)supportedDiagModes {
    [self.parameters sdl_setObject:supportedDiagModes forName:SDLRPCParameterNameSupportedDiagnosticModes];
}

- (nullable NSArray<NSNumber *> *)supportedDiagModes {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameSupportedDiagnosticModes ofClass:NSNumber.class error:nil];
}

- (void)setHmiCapabilities:(nullable SDLHMICapabilities *)hmiCapabilities {
    [self.parameters sdl_setObject:hmiCapabilities forName:SDLRPCParameterNameHMICapabilities];
}

- (nullable SDLHMICapabilities *)hmiCapabilities {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHMICapabilities ofClass:SDLHMICapabilities.class error:nil];
}

- (void)setSdlVersion:(nullable NSString *)sdlVersion {
    [self.parameters sdl_setObject:sdlVersion forName:SDLRPCParameterNameSDLVersion];
}

- (nullable NSString *)sdlVersion {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSDLVersion ofClass:NSString.class error:nil];
}

- (void)setSystemSoftwareVersion:(nullable NSString *)systemSoftwareVersion {
    [self.parameters sdl_setObject:systemSoftwareVersion forName:SDLRPCParameterNameSystemSoftwareVersion];
}

- (nullable NSString *)systemSoftwareVersion {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSystemSoftwareVersion ofClass:NSString.class error:nil];
}

- (void)setIconResumed:(nullable NSNumber<SDLBool> *)iconResumed {
    [self.parameters sdl_setObject:iconResumed forName:SDLRPCParameterNameIconResumed];
}

- (nullable NSNumber<SDLBool> *)iconResumed {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameIconResumed ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
