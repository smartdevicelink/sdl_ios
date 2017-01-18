//  SDLTouchEventCapabilities.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTouchEventCapabilities : SDLRPCStruct

@property (strong) NSNumber<SDLBool> *pressAvailable;
@property (strong) NSNumber<SDLBool> *multiTouchAvailable;
@property (strong) NSNumber<SDLBool> *doublePressAvailable;

@end

NS_ASSUME_NONNULL_END
