//  SDLTouchEventCapabilities.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTouchEventCapabilities : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLBool> *pressAvailable;
@property (strong, nonatomic) NSNumber<SDLBool> *multiTouchAvailable;
@property (strong, nonatomic) NSNumber<SDLBool> *doublePressAvailable;

@end

NS_ASSUME_NONNULL_END
