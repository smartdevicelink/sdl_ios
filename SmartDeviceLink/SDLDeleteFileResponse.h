//  SDLDeleteFileResponse.h
//


#import "SDLRPCResponse.h"

/**
 Response to SDLDeleteFile

 Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteFileResponse : SDLRPCResponse

@property (strong, nonatomic) NSNumber<SDLInt> *spaceAvailable;

@end

NS_ASSUME_NONNULL_END
