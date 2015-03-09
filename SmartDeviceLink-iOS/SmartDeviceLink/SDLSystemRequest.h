//  SDLSystemRequest.h
//



#import "SDLRPCRequest.h"

#import "SDLRequestType.h"


/** An asynchronous request from the device; binary data can be included in hybrid part of message for some requests<br> (such as HTTP, Proprietary, or Authentication requests)
 * <p>
 * @since SmartDeviceLink 3.0
 *
 */
@interface SDLSystemRequest : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLRequestType* requestType;
@property(strong) NSString* fileName;

@end
