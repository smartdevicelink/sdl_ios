//  SDLDiagnosticMessage.h
//



#import "SDLRPCRequest.h"

/** Non periodic vehicle diagnostic request
 *
 * @Since SmartDeviceLink 3.0
 *
 */
@interface SDLDiagnosticMessage : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* targetID;
@property(strong) NSNumber* messageLength;
@property(strong) NSMutableArray* messageData;

@end
