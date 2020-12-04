//  SDLRequestType.h
//


#import "SDLEnum.h"

/**
 A type of system request. Used in SystemRequest.
 */
typedef SDLEnum SDLRequestType NS_TYPED_ENUM;

/**
 An HTTP request
 */
extern SDLRequestType const SDLRequestTypeHTTP;

/**
 A file resumption request
 */
extern SDLRequestType const SDLRequestTypeFileResume;

/**
 An authentication request
 */
extern SDLRequestType const SDLRequestTypeAuthenticationRequest;

/**
 An authentication challenge
 */
extern SDLRequestType const SDLRequestTypeAuthenticationChallenge;

/**
 An authentication acknowledgment
 */
extern SDLRequestType const SDLRequestTypeAuthenticationAck;

/**
 An proprietary formatted request
 */
extern SDLRequestType const SDLRequestTypeProprietary;

/**
 An Query Apps request
 */
extern SDLRequestType const SDLRequestTypeQueryApps;

/**
 A Launch Apps request
 */
extern SDLRequestType const SDLRequestTypeLaunchApp;

/**
 The URL for a lock screen icon
 */
extern SDLRequestType const SDLRequestTypeLockScreenIconURL;

/**
 A traffic message channel request
 */
extern SDLRequestType const SDLRequestTypeTrafficMessageChannel;

/**
 A driver profile request
 */
extern SDLRequestType const SDLRequestTypeDriverProfile;

/**
 A voice search request
 */
extern SDLRequestType const SDLRequestTypeVoiceSearch;

/**
 A navigation request
 */
extern SDLRequestType const SDLRequestTypeNavigation;

/**
 A phone request
 */
extern SDLRequestType const SDLRequestTypePhone;

/**
 A climate request
 */
extern SDLRequestType const SDLRequestTypeClimate;

/**
 A settings request
 */
extern SDLRequestType const SDLRequestTypeSettings;

/**
 A vehicle diagnostics request
 */
extern SDLRequestType const SDLRequestTypeVehicleDiagnostics;

/**
 An emergency request
 */
extern SDLRequestType const SDLRequestTypeEmergency;

/**
 A media request
 */
extern SDLRequestType const SDLRequestTypeMedia;

/**
 A firmware over-the-air request
 */
extern SDLRequestType const SDLRequestTypeFOTA;

/**
 A request that is OEM specific using the `RequestSubType` in SystemRequest
 */
extern SDLRequestType const SDLRequestTypeOEMSpecific;

/**
 A request for an icon url
 */
extern SDLRequestType const SDLRequestTypeIconURL;

