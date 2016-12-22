//  SDLImageResolution.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLImageResolution : SDLRPCStruct

@property (strong) NSNumber<SDLInt> *resolutionWidth;
@property (strong) NSNumber<SDLInt> *resolutionHeight;

@end

NS_ASSUME_NONNULL_END
