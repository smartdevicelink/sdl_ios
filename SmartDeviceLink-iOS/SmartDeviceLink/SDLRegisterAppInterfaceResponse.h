//  SDLRegisterAppInterfaceResponse.h
//



#import "SDLRPCResponse.h"

@class SDLSyncMsgVersion;
@class SDLLanguage;
@class SDLDisplayCapabilities;
@class SDLPresetBankCapabilities;
@class SDLVehicleType;


/**
 * @abstract Register AppInterface Response is sent, when SDLRegisterAppInterface has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLRegisterAppInterfaceResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLRegisterAppInterfaceResponse object
 */
-(instancetype) init;
/**
 * Constructs a new SDLRegisterAppInterfaceResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The version of the SDL&reg; SmartDeviceLink interface
 * @discussion a SDLMsgVersion object representing version of the SDL&reg;
 *            SmartDeviceLink interface
 *            <p>
 *            <b>Notes: </b>To be compatible, app msg major version number
 *            must be less than or equal to SDL&reg; major version number.
 *            If msg versions are incompatible, app has 20 seconds to
 *            attempt successful RegisterAppInterface (w.r.t. msg version)
 *            on underlying protocol session, else will be terminated. Major
 *            version number is a compatibility declaration. Minor version
 *            number indicates minor functional variations (e.g. features,
 *            capabilities, bug fixes) when sent from SDL&reg; to app (in
 *            RegisterAppInterface response). However, the minor version
 *            number sent from the app to SDL&reg; (in RegisterAppInterface
 *            request) is ignored by SDL&reg;
 */
@property(strong) SDLSyncMsgVersion* syncMsgVersion;
/**
 * @abstract Sets an enumeration indicating what language the application intends to
 * use for user interaction (Display, TTS and VR)
 */
@property(strong) SDLLanguage* language;
/**
 * @abstract An enumeration indicating what language the application intends to
 * use for user interaction ( Display)
 * @since SmartDeviceLink 2.0
 */
@property(strong) SDLLanguage* hmiDisplayLanguage;
/**
 * @abstract Display Capabilities
 */
@property(strong) SDLDisplayCapabilities* displayCapabilities;
/**
 * @abstract Button Capabilities
 */
@property(strong) NSMutableArray* buttonCapabilities;
/**
 * @abstract SoftButton Capabilities
 */
@property(strong) NSMutableArray* softButtonCapabilities;
/**
 * @abstract Preset BankCapabilities
 */
@property(strong) SDLPresetBankCapabilities* presetBankCapabilities;
/**
 * @abstract Gets/Sets hmiZoneCapabilities when application interface is registered.
 */
@property(strong) NSMutableArray* hmiZoneCapabilities;
/**
 * @abstract Gets/Sets speechCapabilities when application interface is registered.
 */
@property(strong) NSMutableArray* speechCapabilities;
/**
 * @abstract Gets/Sets prerecordedSpeech when application interface is registered.
 */
@property(strong) NSMutableArray* prerecordedSpeech;
/**
 * @abstract Gets/Sets vrCapabilities when application interface is registered.
 */
@property(strong) NSMutableArray* vrCapabilities;
/**
 * @abstract Gets/Sets AudioPassThruCapabilities when application interface is registered.
 */
@property(strong) NSMutableArray* audioPassThruCapabilities;
/**
 * @abstract Gets/Sets VehicleType when application interface is registered.
 */
@property(strong) SDLVehicleType* vehicleType;
@property(strong) NSMutableArray* supportedDiagModes;

@end
