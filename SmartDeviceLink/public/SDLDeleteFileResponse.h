//  SDLDeleteFileResponse.h
//


#import "SDLRPCResponse.h"


NS_ASSUME_NONNULL_BEGIN

/**
 Response to SDLDeleteFile

 Since SmartDeviceLink 2.0
 */
@interface SDLDeleteFileResponse : SDLRPCResponse

/**
 The remaining available space for your application to store data on the remote system.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *spaceAvailable;

@end

NS_ASSUME_NONNULL_END
