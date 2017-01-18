//  SDLDiagnosticMessageResponse.h
//


#import "SDLRPCResponse.h"

/** SDLDiagnosticMessageResponse is sent, when SDLDiagnosticMessage has been called.
 * Since<b>SmartDeviceLink 3.0</b>
 */
@interface SDLDiagnosticMessageResponse : SDLRPCResponse

@property (strong, nonatomic) NSMutableArray<NSNumber<SDLInt> *> *messageDataResult;

@end
