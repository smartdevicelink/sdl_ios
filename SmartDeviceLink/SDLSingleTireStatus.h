//  SDLSingleTireStatus.h
//

#import "SDLRPCMessage.h"

@class SDLComponentVolumeStatus;


/**
 * Tire pressure status of a single tire.
 *
 * @since SmartDeviceLink 2.0
 */
@interface SDLSingleTireStatus : SDLRPCStruct

/**
 * @abstract The volume status of a single tire
 */
@property (strong) SDLComponentVolumeStatus *status;

@end
