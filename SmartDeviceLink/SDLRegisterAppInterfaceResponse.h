//  SDLRegisterAppInterfaceResponse.h
//


#import "SDLRPCResponse.h"

#import "SDLHMIZoneCapabilities.h"
#import "SDLLanguage.h"
#import "SDLPrerecordedSpeech.h"
#import "SDLSpeechCapabilities.h"
#import "SDLVRCapabilities.h"

@class SDLAudioPassThruCapabilities;
@class SDLButtonCapabilities;
@class SDLDisplayCapabilities;
@class SDLHMICapabilities;
@class SDLPresetBankCapabilities;
@class SDLSoftButtonCapabilities;
@class SDLSyncMsgVersion;
@class SDLVehicleType;


/**
 * @abstract Register AppInterface Response is sent, when SDLRegisterAppInterface has been called
 *
 * Since SmartDeviceLink 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse

/**
 * @see SDLSyncMsgVersion
 *
 * Optional
 */
@property (nullable, strong) SDLSyncMsgVersion *syncMsgVersion;

/**
 * The currently active VR+TTS language on Sync.
 *
 * @see SDLLanguage
 *
 * Optional
 */
@property (nullable, strong) SDLLanguage language;

/**
 * The currently active display language on Sync
 *
 * @see SDLLanguage
 * @since SmartDeviceLink 2.0
 *
 * Optional
 */
@property (nullable, strong) SDLLanguage hmiDisplayLanguage;

/**
 * @see SDLDisplayCapabilities
 *
 * Optional
 */
@property (nullable, strong) SDLDisplayCapabilities *displayCapabilities;

/**
 * @see SDLButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLButtonCapabilities
 */
@property (nullable, strong) NSMutableArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 * If returned, the platform supports on-screen SoftButtons
 *
 * @see SDLSoftButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSoftButtonCapabilities
 */
@property (nullable, strong) NSMutableArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;

/**
 * If returned, the platform supports custom on-screen Presets
 *
 * @see SDLPresetBankCapabilities
 *
 * Optional
 */
@property (nullable, strong) SDLPresetBankCapabilities *presetBankCapabilities;

/**
 * @see SDLHMIZoneCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLHMIZoneCapabilities
 */
@property (nullable, strong) NSMutableArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;

/**
 * @see SDLSpeechCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSpeechCapabilities
 */
@property (nullable, strong) NSMutableArray<SDLSpeechCapabilities> *speechCapabilities;

/**
 * @see SDLPrerecordedSpeech
 *
 * Optional, Array of length 1 - 100, of SDLPrerecordedSpeech
 */
@property (nullable, strong) NSMutableArray<SDLPrerecordedSpeech> *prerecordedSpeech;

/**
 * @see SDLVRCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLVRCapabilities
 */
@property (nullable, strong) NSMutableArray<SDLVRCapabilities> *vrCapabilities;

/**
 * @see SDLAudioPassThruCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLAudioPassThruCapabilities
 */
@property (nullable, strong) NSMutableArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;

/**
 * Specifies the vehicle's type
 *
 * @see SDLVehicleType
 *
 * Optional, Array of length 1 - 100, of SDLVehicleType
 */
@property (nullable, strong) SDLVehicleType *vehicleType;

/**
 * Specifies the white-list of supported diagnostic modes (0x00-0xFF) capable for DiagnosticMessage requests. If a mode outside this list is requested, it will be rejected.
 *
 * Optional, Array of length 1 - 100, Integer 0 - 255
 */
@property (nullable, strong) NSMutableArray<NSNumber<SDLInt> *> *supportedDiagModes;

/**
 * @see SDLHMICapabilities
 *
 * Optional
 */
@property (nullable, strong) SDLHMICapabilities *hmiCapabilities;

/**
 * The SmartDeviceLink version
 *
 * Optional, String max length 100
 */
@property (nullable, strong) NSString *sdlVersion;

/**
 * The software version of the system that implements the SmartDeviceLink core
 *
 * Optional, String max length 100
 */
@property (nullable, strong) NSString *systemSoftwareVersion;


@end

NS_ASSUME_NONNULL_END
