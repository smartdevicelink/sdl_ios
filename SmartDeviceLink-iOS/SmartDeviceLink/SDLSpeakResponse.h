//  SDLSpeakResponse.h
//



#import "SDLRPCResponse.h"

/**
 * Speak Response is sent, when Speak has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLSpeakResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLSpeakResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLSpeakResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end

