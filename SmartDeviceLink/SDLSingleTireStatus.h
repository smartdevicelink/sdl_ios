//  SDLSingleTireStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLComponentVolumeStatus.h"

/**
 * Tire pressure status of a single tire.
 *
 * @since SmartDeviceLink 2.0
 */
@interface SDLSingleTireStatus : SDLRPCStruct

/**
 * @abstract The volume status of a single tire
 */
@property (strong, nonatomic) SDLComponentVolumeStatus status;

@end
