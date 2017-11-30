//  SDLAlertResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Sent after SDLAlert has been sent
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlertResponse : SDLRPCResponse

@property (nullable, strong, nonatomic) NSNumber<SDLInt> *tryAgainTime;

@end

NS_ASSUME_NONNULL_END
