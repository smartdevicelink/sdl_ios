//
//  SDLOnAppCapabilityUpdated.h
//  SmartDeviceLink
//

#import "SDLRPCNotification.h"

@class SDLAppCapability;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A notification to inform SDL Core that a specific app capability has changed.
 */
@interface SDLOnAppCapabilityUpdated : SDLRPCNotification

/**
 * Convenience init for required parameters
 *
 *  @param appCapability The system capability that has been updated
 *  @return A SDLOnAppCapabilityUpdated object
 */
- (instancetype)initWithAppCapability:(SDLAppCapability *)appCapability;

/**
 *  The app capability that has been updated.
 *
 *  SDLAppCapability, Required
 */
@property (strong, nonatomic) SDLAppCapability *appCapability;

@end

NS_ASSUME_NONNULL_END
