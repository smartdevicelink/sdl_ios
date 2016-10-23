//  SDLAlertResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Sent after SDLAlert has been sent
 * @since SDL 1.0
 */
@interface SDLAlertResponse : SDLRPCResponse

@property (strong) NSNumber<SDLInt> *tryAgainTime;

@end
