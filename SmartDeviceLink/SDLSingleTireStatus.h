//  SDLSingleTireStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLComponentVolumeStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Tire pressure status of a single tire.
 *
 * @since SmartDeviceLink 2.0
 */
@interface SDLSingleTireStatus : SDLRPCStruct

/**
 * The volume status of a single tire

 Required
 */
@property (strong, nonatomic) SDLComponentVolumeStatus status;

@end

NS_ASSUME_NONNULL_END
