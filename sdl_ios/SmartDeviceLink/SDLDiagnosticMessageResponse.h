//  SDLDiagnosticMessageResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLDiagnosticMessageResponse is sent, when SDLDiagnosticMessage has been called.
 * Since<b>SmartDeviceLink 3.0</b>
 */
@interface SDLDiagnosticMessageResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* messageDataResult;

@end
