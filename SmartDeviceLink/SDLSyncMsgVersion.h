//  SDLSyncMsgVersion.h
//


#import "SDLRPCMessage.h"

/**
 * Specifies the version number of the SDL V4 interface. This is used by both the application and SDL to declare what interface version each is using.
 * 
 * @since SDL 1.0
 */
@interface SDLSyncMsgVersion : SDLRPCStruct

/**
 * @abstract The major version indicates versions that is not-compatible to previous versions
 * 
 * Required, Integer, 1 - 10
 */
@property (strong) NSNumber<SDLInt> *majorVersion;
/**
 * @abstract The minor version indicates a change to a previous version that should still allow to be run on an older version (with limited functionality)
 * 
 * Required, Integer, 0 - 1000
 */
@property (strong) NSNumber<SDLInt> *minorVersion;

@end
