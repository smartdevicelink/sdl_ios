//  SDLPutFileResponse.h
//


#import "SDLRPCResponse.h"

/**
 Response to SDLPutFile

 Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLPutFileResponse : SDLRPCResponse

/**
 *  Provides the total local space available in SDL Core for the registered app. If the transfer has systemFile enabled, then the value will be set to 0 automatically.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *spaceAvailable;

@end

NS_ASSUME_NONNULL_END
