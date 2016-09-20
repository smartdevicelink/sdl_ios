//  SDLDiagnosticMessageResponse.h
//


#import "SDLRPCResponse.h"

/** SDLDiagnosticMessageResponse is sent, when SDLDiagnosticMessage has been called.
 * Since<b>SmartDeviceLink 3.0</b>
 */
@interface SDLDiagnosticMessageResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSMutableArray<NSNumber *> *messageDataResult;

@end
