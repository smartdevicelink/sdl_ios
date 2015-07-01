//  SDLRegisterAppInterfaceResponse.h
//


#import "SDLRPCResponse.h"

@class SDLLanguage;
@class SDLDisplayCapabilities;
@class SDLHMICapabilities;
@class SDLPresetBankCapabilities;
@class SDLSyncMsgVersion;
@class SDLVehicleType;


/**
 * @abstract Register AppInterface Response is sent, when SDLRegisterAppInterface has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLRegisterAppInterfaceResponse object
 */
- (instancetype)init;

/**
 * Constructs a new SDLRegisterAppInterfaceResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @see SDLSyncMsgVersion
 *
 * Optional
 */
@property (strong) SDLSyncMsgVersion *syncMsgVersion;

/**
 * The currently active VR+TTS language on Sync.
 *
 * @see SDLLanguage
 *
 * Optional
 */
@property (strong) SDLLanguage *language;

/**
 * The currently active display language on Sync
 *
 * @see SDLLanguage
 * @since SmartDeviceLink 2.0
 *
 * Optional
 */
@property (strong) SDLLanguage *hmiDisplayLanguage;

/**
 * @see SDLDisplayCapabilities
 *
 * Optional
 */
@property (strong) SDLDisplayCapabilities *displayCapabilities;

/**
 * @see SDLButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLButtonCapabilities
 */
@property (strong) NSMutableArray *buttonCapabilities;

/**
 * If returned, the platform supports on-screen SoftButtons
 *
 * @see SDLSoftButtonCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSoftButtonCapabilities
 */
@property (strong) NSMutableArray *softButtonCapabilities;

/**
 * If returned, the platform supports custom on-screen Presets
 *
 * @see SDLPresetBankCapabilities
 *
 * Optional
 */
@property (strong) SDLPresetBankCapabilities *presetBankCapabilities;

/**
 * @see SDLHMIZoneCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLHMIZoneCapabilities
 */
@property (strong) NSMutableArray *hmiZoneCapabilities;

/**
 * @see SDLSpeechCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLSpeechCapabilities
 */
@property (strong) NSMutableArray *speechCapabilities;

/**
 * @see SDLPrerecordedSpeech
 *
 * Optional, Array of length 1 - 100, of SDLPrerecordedSpeech
 */
@property (strong) NSMutableArray *prerecordedSpeech;

/**
 * @see SDLVRCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLVRCapabilities
 */
@property (strong) NSMutableArray *vrCapabilities;

/**
 * @see SDLAudioPassThruCapabilities
 *
 * Optional, Array of length 1 - 100, of SDLAudioPassThruCapabilities
 */
@property (strong) NSMutableArray *audioPassThruCapabilities;

/**
 * Specifies the vehicle's type
 *
 * @see SDLVehicleType
 *
 * Optional, Array of length 1 - 100, of SDLVehicleType
 */
@property (strong) SDLVehicleType *vehicleType;

/**
 * Specifies the white-list of supported diagnostic modes (0x00-0xFF) capable for DiagnosticMessage requests. If a mode outside this list is requested, it will be rejected.
 *
 * Optional, Array of length 1 - 100, Integer 0 - 255
 */
@property (strong) NSMutableArray *supportedDiagModes;

/**
 * @see SDLHMICapabilities
 *
 * Optional
 */
@property (strong) SDLHMICapabilities *hmiCapabilities;

/**
 * The SmartDeviceLink version
 *
 * Optional, String max length 100
 */
@property (strong) NSString *sdlVersion;

/**
 * The software version of the system that implements the SmartDeviceLink core
 *
 * Optional, String max length 100
 */
@property (strong) NSString *systemSoftwareVersion;


@end
