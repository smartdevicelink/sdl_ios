//  SDLImageResolution.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLImageResolution : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLInt> *resolutionWidth;
@property (strong, nonatomic) NSNumber<SDLInt> *resolutionHeight;

@end

NS_ASSUME_NONNULL_END
