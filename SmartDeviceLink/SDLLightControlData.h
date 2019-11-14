//  SDLLightControlData.h
//

#import "SDLRPCMessage.h"

@class SDLLightState;

NS_ASSUME_NONNULL_BEGIN

/// Data about the current light controls
///
/// @since SDL 5.0
@interface SDLLightControlData : SDLRPCStruct

/**
 Constructs a newly allocated SDLLightControlData object with lightState

 @param lightState An array of LightNames and their current or desired status
 @return An instance of the SDLLightControlData class
 */
- (instancetype)initWithLightStates:(NSArray<SDLLightState *> *)lightState;

/**
 * @abstract An array of LightNames and their current or desired status.
 * Status of the LightNames that are not listed in the array shall remain unchanged.
 *
 * Required, NSArray of type SDLLightState minsize="1" maxsize="100"
 */
@property (strong, nonatomic) NSArray<SDLLightState *> *lightState;

@end

NS_ASSUME_NONNULL_END
