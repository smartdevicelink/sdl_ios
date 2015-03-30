//  SDLPutFileResponse.h
//



#import "SDLRPCResponse.h"

/**
 * Put File Response is sent, when SDLPutFile has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLPutFileResponse : SDLRPCResponse {}
/**
 * @abstract Constructs a new SDLPutFileResponse object
 */
-(instancetype) init;
/**
 * @abstract Constructs a new SDLPutFileResponse object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;
@property(strong) NSNumber* spaceAvailable;
@end
