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
@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse

/**
 * @see SDLSyncMsgVersion
 *
 * Optional
 */
@property (strong, nonatomic) SDLSyncMsgVersion *syncMsgVersion;

/**
 * The currently active VR+TTS language on Sync.
 *
 * @see SDLLanguage
 *
 * Optional
 */
@property (strong, nonatomic) SDLLanguage language;

/**
 * The currently active display language on Sync
 *
 * @see SDLLanguage
 * @since SmartDeviceLink 2.0
 *
 * Optional
 */
@property (strong, nonatomic) SDLLanguage hmiDisplayLanguage;

/**
 * @see SDLDisplayCapabilities
 *
 * Optional
 */
@property (strong, nonatomic) SDLDisplayCapabilities *displayCapabilities;

/**
 * @see SDLButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLButtonCapabilities
 */
@property (strong, nonatomic) NSMutableArray<SDLButtonCapabilities *> *buttonCapabilities;

/**
 * If returned, the platform supports on-screen SoftButtons
 *
 * @see SDLSoftButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSoftButtonCapabilities
 */
@property (strong, nonatomic) NSMutableArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;

/**
 * If returned, the platform supports custom on-screen Presets
 *
 * @see SDLPresetBankCapabilities
 *
 * Optional
 */
@property (strong, nonatomic) SDLPresetBankCapabilities *presetBankCapabilities;

/**
 * @see SDLHMIZoneCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLHMIZoneCapabilities
 */
@property (strong, nonatomic) NSMutableArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;

/**
 * @see SDLSpeechCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSpeechCapabilities
 */
@property (strong, nonatomic) NSMutableArray<SDLSpeechCapabilities> *speechCapabilities;

/**
 * @see SDLPrerecordedSpeech
 *
 * Optional, Array of length 1 - 100, of SDLPrerecordedSpeech
 */
@property (strong, nonatomic) NSMutableArray<SDLPrerecordedSpeech> *prerecordedSpeech;

/**
 * @see SDLVRCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLVRCapabilities
 */
@property (strong, nonatomic) NSMutableArray<SDLVRCapabilities> *vrCapabilities;

/**
 * @see SDLAudioPassThruCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLAudioPassThruCapabilities
 */
@property (strong, nonatomic) NSMutableArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;

/**
 * Specifies the vehicle's type
 *
 * @see SDLVehicleType
 *
 * Optional, Array of length 1 - 100, of SDLVehicleType
 */
@property (strong, nonatomic) SDLVehicleType *vehicleType;

/**
 * Specifies the white-list of supported diagnostic modes (0x00-0xFF) capable for DiagnosticMessage requests. If a mode outside this list is requested, it will be rejected.
 *
 * Optional, Array of length 1 - 100, Integer 0 - 255
 */
@property (strong, nonatomic) NSMutableArray<NSNumber<SDLInt> *> *supportedDiagModes;

/**
 * @see SDLHMICapabilities
 *
 * Optional
 */
@property (strong, nonatomic) SDLHMICapabilities *hmiCapabilities;

/**
 * The SmartDeviceLink version
 *
 * Optional, String max length 100
 */
@property (strong, nonatomic) NSString *sdlVersion;

/**
 * The software version of the system that implements the SmartDeviceLink core
 *
 * Optional, String max length 100
 */
@property (strong, nonatomic) NSString *systemSoftwareVersion;


@end
