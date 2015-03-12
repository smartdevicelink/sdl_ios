//  SDLEndAudioPassThruResponse.h
//



#import "SDLRPCResponse.h"

/**
 * SDLEndAudioPassThruResponse is sent, when SDLEndAudioPassThru has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLEndAudioPassThruResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
