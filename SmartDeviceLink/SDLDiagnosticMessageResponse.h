//  SDLDiagnosticMessageResponse.h
//


#import "SDLRPCResponse.h"

/**
 Response to SDLDiagnosticMessage

 Since SmartDeviceLink 3.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDiagnosticMessageResponse : SDLRPCResponse

@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *messageDataResult;

@end

NS_ASSUME_NONNULL_END
