/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


#import "SDLRPCResponse.h"

#import "SDLHMIZoneCapabilities.h"
#import "SDLLanguage.h"
#import "SDLPrerecordedSpeech.h"
#import "SDLSpeechCapabilities.h"
#import "SDLVrCapabilities.h"

@class SDLAudioPassThruCapabilities;
@class SDLButtonCapabilities;
@class SDLDisplayCapabilities;
@class SDLHMICapabilities;
@class SDLPresetBankCapabilities;
@class SDLSoftButtonCapabilities;
@class SDLMsgVersion;
@class SDLVehicleType;


NS_ASSUME_NONNULL_BEGIN

/**
 * Response to SDLRegisterAppInterface
 *
 * @since SDL 1.0
 */
@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse

/**
 * @param sdlMsgVersion - sdlMsgVersion
 * @param language - language
 * @param hmiDisplayLanguage - hmiDisplayLanguage
 * @param hmiZoneCapabilities - hmiZoneCapabilities
 * @param speechCapabilities - speechCapabilities
 * @param prerecordedSpeech - prerecordedSpeech
 * @param vrCapabilities - vrCapabilities
 * @param audioPassThruCapabilities - audioPassThruCapabilities
 * @param pcmStreamCapabilities - pcmStreamCapabilities
 * @param vehicleType - vehicleType
 * @param supportedDiagModes - supportedDiagModes
 * @param hmiCapabilities - hmiCapabilities
 * @param sdlVersion - sdlVersion
 * @param systemSoftwareVersion - systemSoftwareVersion
 * @param iconResumed - iconResumed
 * @return A SDLRegisterAppInterfaceResponse object
 */
- (instancetype)initWithSdlMsgVersion:(nullable SDLMsgVersion *)sdlMsgVersion language:(nullable SDLLanguage)language hmiDisplayLanguage:(nullable SDLLanguage)hmiDisplayLanguage hmiZoneCapabilities:(nullable NSArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities speechCapabilities:(nullable NSArray<SDLSpeechCapabilities> *)speechCapabilities prerecordedSpeech:(nullable NSArray<SDLPrerecordedSpeech> *)prerecordedSpeech vrCapabilities:(nullable NSArray<SDLVRCapabilities> *)vrCapabilities audioPassThruCapabilities:(nullable NSArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities pcmStreamCapabilities:(nullable SDLAudioPassThruCapabilities *)pcmStreamCapabilities vehicleType:(nullable SDLVehicleType *)vehicleType supportedDiagModes:(nullable NSArray<NSNumber<SDLUInt> *> *)supportedDiagModes hmiCapabilities:(nullable SDLHMICapabilities *)hmiCapabilities sdlVersion:(nullable NSString *)sdlVersion systemSoftwareVersion:(nullable NSString *)systemSoftwareVersion iconResumed:(nullable NSNumber<SDLBool> *)iconResumed;

/**
 * Specifies the negotiated version number of the SmartDeviceLink protocol that is to be supported by the mobile application.
 *
 * SDLMsgVersion, Optional
 *
 * @since SDL 1.0
 */
@property(nullable, strong, nonatomic) SDLMsgVersion *sdlMsgVersion;

/**
 * The currently active VR+TTS language on the module. See "Language" for options.
 *
 * SDLLanguage, Optional
 *
 * @since SDL 1.0
 */
@property (nullable, strong, nonatomic) SDLLanguage language;

/**
 * The currently active display language on the module. See "Language" for options.
 *
 * SDLLanguage, Optional
 *
 * @since SDL 2.0
 */
@property (nullable, strong, nonatomic) SDLLanguage hmiDisplayLanguage;

/**
 * Contains information about the display's capabilities.
 *
 * SDLDisplayCapabilities, Optional
 *
 * @since SDL 1.0
 */
@property (nullable, strong, nonatomic) SDLDisplayCapabilities *displayCapabilities  __deprecated_msg("This parameter is deprecated and replaced by GetSystemCapability using DISPLAY. Deprecated in sdl_ios v6.4 / RPC spec 6.0. You can use the SystemCapabilityManager to have automatic full compatibility support.");

/**
 * Contains information about the head unit button capabilities.
 *
 * Array of SDLButtonCapabilities, Optional, Array of length 1 - 100
 *
 * @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities  __deprecated_msg("This parameter is deprecated and replaced by GetSystemCapability using DISPLAY. Deprecated in sdl_ios v6.4 / RPC spec 6.0. You can use the SystemCapabilityManager to have automatic full compatibility support.");

/**
 * Contains information about the head unit soft button capabilities.
 *
 * Array of SDLSoftButtonCapabilities, Optional, Array of length 1 - 100
 *
 * @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities __deprecated_msg("This parameter is deprecated and replaced by GetSystemCapability using DISPLAY. Deprecated in sdl_ios v6.4 / RPC spec 6.0. You can use the SystemCapabilityManager to have automatic full compatibility support.");

/**
 * If returned, the platform supports custom on-screen Presets
 *
 * SDLPresetBankCapabilities, Optional
 *
 * @since SDL 2.0
 */
@property (nullable, strong, nonatomic) SDLPresetBankCapabilities *presetBankCapabilities __deprecated_msg("This parameter is deprecated and replaced by GetSystemCapability using DISPLAY. Deprecated in sdl_ios v6.4 / RPC spec 6.0. You can use the SystemCapabilityManager to have automatic full compatibility support.");

/**
 * Contains information about the HMI zone capabilities.
 *
 * Array of SDLHMIZoneCapabilities, Optional, Array of length 1 - 100
 *
 * @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;

/**
 * Contains information about the text-to-speech capabilities.
 *
 * Array of SDLSpeechCapabilities, Optional, Array of length 1 - 100
 *
 * @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLSpeechCapabilities> *speechCapabilities;

/**
 * Contains a list of prerecorded speech items present on the platform.
 *
 * Array of SDLPrerecordedSpeech, Optional, Array of length 1 - 100
 *
 * @since SDL 3.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLPrerecordedSpeech> *prerecordedSpeech;

/**
 * Contains information about the VR capabilities.
 *
 * Array of SDLVRCapabilities, Optional, Array of length 1 - 100
 *
 * @since SDL 1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLVRCapabilities> *vrCapabilities;

/**
 * Describes different audio type configurations for PerformAudioPassThru, e.g. {8kHz,8-bit,PCM}. The audio is recorded in monaural.
 *
 * Array of SDLAudioPassThruCapabilities, Optional, Array of length 1 - 100
 *
 * @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;

/**
 * Describes different audio type configurations for the audio PCM stream service, e.g. {8kHz,8-bit,PCM}
 *
 * SDLAudioPassThruCapabilities, Optional
 *
 * @since SDL 4.1
 */
@property (nullable, strong, nonatomic) SDLAudioPassThruCapabilities *pcmStreamCapabilities;

/**
 * Specifies the connected vehicle's type.
 *
 * SDLVehicleType, Optional
 *
 * @since SDL 2.0
 */
@property (nullable, strong, nonatomic) SDLVehicleType *vehicleType;

/**
 * Specifies the white-list of supported diagnostic modes (0x00-0xFF) capable for DiagnosticMessage requests. If a mode outside this list is requested, it will be rejected.
 *
 * Array of Integers, Optional, Array of length 1 - 100, Value range: 0 - 255
 *
 * @since SDL 3.0
 */
@property (nullable, strong, nonatomic) NSArray<NSNumber *> *supportedDiagModes;

/**
 * Specifies the HMI capabilities.
 *
 * SDLHMICapabilities, Optional
 *
 * @since SDL 3.0
 */
@property (nullable, strong, nonatomic) SDLHMICapabilities *hmiCapabilities;

/**
 * The version of SDL Core running on the connected head unit
 *
 * String, Optional, Max length: 100
 *
 * @since SDL 3.0
 */
@property (nullable, strong, nonatomic) NSString *sdlVersion;

/**
 * The software version of the system that implements the SmartDeviceLink core.
 *
 * String, Optional, Max length: 100
 *
 * @since SDL 3.0
 */
@property (nullable, strong, nonatomic) NSString *systemSoftwareVersion;

/**
 * Existence of apps icon at system. If true, apps icon was resumed at system. If false, apps icon is not resumed at system.
 *
 * Bool, Optional
 *
 * @since SDL 5.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *iconResumed;

@end

NS_ASSUME_NONNULL_END
