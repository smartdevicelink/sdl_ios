//  SDLSpeakResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Speak Response is sent, when Speak has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLSpeakResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLSpeakResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSpeakResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
