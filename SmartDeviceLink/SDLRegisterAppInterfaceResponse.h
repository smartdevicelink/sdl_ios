//  SDLRegisterAppInterfaceResponse.h
//


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
@class SDLSyncMsgVersion;
@class SDLVehicleType;


/**
 Response to SDLRegisterAppInterface

 Since SmartDeviceLink 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse

/**
 The RPC spec version supported by the connected IVI system.

 Optional
 */
@property (nullable, strong, nonatomic) SDLSyncMsgVersion *syncMsgVersion;

/**
 The currently active VR+TTS language on the module. See "Language" for options.

 Optional
 */
@property (nullable, strong, nonatomic) SDLLanguage language;

/**
 The currently active display language on the module. See "Language" for options.

 Since SmartDeviceLink 2.0

 Optional
 */
@property (nullable, strong, nonatomic) SDLLanguage hmiDisplayLanguage;

/**
 Contains information about the display for the SDL system to which the application is currently connected.

 Optional
 */
@property (nullable, strong, nonatomic) SDLDisplayCapabilities *displayCapabilities;

/**
 Provides information about the capabilities of a SDL HMI button.

 Optional, Array of length 1 - 100, of SDLButtonCapabilities
 */
@property (nullable, strong, nonatomic) NSArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 Contains information about a SoftButton's capabilities.

 Optional, Array of length 1 - 100, of SDLSoftButtonCapabilities
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;

/**
 If returned, the platform supports custom on-screen Presets
 
 Optional
 */
@property (nullable, strong, nonatomic) SDLPresetBankCapabilities *presetBankCapabilities;

/**
 Specifies HMI Zones in the vehicle.

 Optional, Array of length 1 - 100, of SDLHMIZoneCapabilities
 */
@property (nullable, strong, nonatomic) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;

/**
 Contains information about TTS capabilities on the SDL platform.

 Optional, Array of length 1 - 100, of SDLSpeechCapabilities
 */
@property (nullable, strong, nonatomic) NSArray<SDLSpeechCapabilities> *speechCapabilities;

/**
 Contains information about the speech capabilities on the SDL platform
 *
 * Optional, Array of length 1 - 100, of SDLPrerecordedSpeech
 */
@property (nullable, strong, nonatomic) NSArray<SDLPrerecordedSpeech> *prerecordedSpeech;

/**
 The VR capabilities of the connected SDL platform.

 Optional, Array of length 1 - 100, of SDLVRCapabilities
 */
@property (nullable, strong, nonatomic) NSArray<SDLVRCapabilities> *vrCapabilities;

/**
 Describes different audio type configurations for SDLPerformAudioPassThru, e.g. {8kHz,8-bit,PCM}

 Optional, Array of length 1 - 100, of SDLAudioPassThruCapabilities
 */
@property (nullable, strong, nonatomic) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;

/**
 Describes different audio type configurations for the audio PCM stream service, e.g. {8kHz,8-bit,PCM}
 */
@property (nullable, strong, nonatomic) SDLAudioPassThruCapabilities *pcmStreamCapabilities;

/**
 Specifies the connected vehicle's type
 */
@property (nullable, strong, nonatomic) SDLVehicleType *vehicleType;

/**
 Specifies the white-list of supported diagnostic modes (0x00-0xFF) capable for DiagnosticMessage requests. If a mode outside this list is requested, it will be rejected.

 Optional, Array of length 1 - 100, Integer 0 - 255
 */
@property (nullable, strong, nonatomic) NSArray<NSNumber<SDLInt> *> *supportedDiagModes;

/**
 Specifies the availability of various SDL features.

 Optional
 */
@property (nullable, strong, nonatomic) SDLHMICapabilities *hmiCapabilities;

/**
 The SmartDeviceLink Core version

 Optional, String max length 100
 */
@property (nullable, strong, nonatomic) NSString *sdlVersion;

/**
 The software version of the system that implements SmartDeviceLink Core

 Optional, String max length 100
 */
@property (nullable, strong, nonatomic) NSString *systemSoftwareVersion;

/**
 Whether or not the app's icon already existed on the system and was resumed. That means that the icon does not need to be sent by the app.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *iconResumed;

@end

NS_ASSUME_NONNULL_END
