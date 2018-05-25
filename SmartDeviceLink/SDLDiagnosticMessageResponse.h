//  SDLDiagnosticMessageResponse.h
//


#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Response to SDLDiagnosticMessage

 Since SmartDeviceLink 3.0
 */
@interface SDLDiagnosticMessageResponse : SDLRPCResponse

/**
 Array of bytes comprising CAN message result.

 Required
 */
@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *messageDataResult;

@end

NS_ASSUME_NONNULL_END
