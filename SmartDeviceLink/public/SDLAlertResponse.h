//  SDLAlertResponse.h
//


#import "SDLRPCResponse.h"

/**
 Response to SDLAlert

 @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlertResponse : SDLRPCResponse

/// Amount of time (in seconds) that an app must wait before resending an alert.
///
/// @since RPC 2.0
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *tryAgainTime;

@end

NS_ASSUME_NONNULL_END
