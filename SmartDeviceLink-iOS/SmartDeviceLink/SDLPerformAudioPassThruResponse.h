//  SDLPerformAudioPassThruResponse.h
//



#import "SDLRPCResponse.h"

/**
 * Perform Audio Pass Thru Response is sent, when PerformAudioPassThru has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLPerformAudioPassThruResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLPerformAudioPassThruResponse object
 */
-(instancetype) init;
/**
 * @abstract Constructs a new SDLPerformAudioPassThruResponse object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@end
