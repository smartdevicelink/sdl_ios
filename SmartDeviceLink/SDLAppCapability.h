//
//  SDLAppCapability.h
//  SmartDeviceLink-iOS
//

#import "SDLRPCStruct.h"
#import "SDLAppCapabilityType.h"

@class SDLVideoStreamingCapability;

NS_ASSUME_NONNULL_BEGIN

@interface SDLAppCapability : SDLRPCStruct

/**
 *  Convenience init for an App Service Capability
 *
 *  @param capability Describes supported capabilities for video streaming
 *  @return A SDLAppCapability object
 */
- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability;


/**
 * Used as a descriptor of what data to expect in this struct. The corresponding param to this enum should be included and the only other param included.
 */
@property (strong, nonatomic) SDLAppCapabilityType appCapabilityType;

/**
 *  Describes supported capabilities for video streaming
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLVideoStreamingCapability *videoStreamingCapability;

@end

NS_ASSUME_NONNULL_END
