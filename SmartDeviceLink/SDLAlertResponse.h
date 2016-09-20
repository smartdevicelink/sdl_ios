//  SDLAlertResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Sent after SDLAlert has been sent
 * @since SDL 1.0
 */
@interface SDLAlertResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSNumber *tryAgainTime;

@end
