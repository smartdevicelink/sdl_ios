//  SDLDiagnosticMessageResponse.h
//


#import "SDLRPCResponse.h"

/** SDLDiagnosticMessageResponse is sent, when SDLDiagnosticMessage has been called.
 * Since<b>SmartDeviceLink 3.0</b>
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDiagnosticMessageResponse : SDLRPCResponse

@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *messageDataResult;

@end

NS_ASSUME_NONNULL_END
