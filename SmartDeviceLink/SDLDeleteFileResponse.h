//  SDLDeleteFileResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Delete File Response is sent, when DeleteFile has been called
 *
 * Since <b>SmartDeviceLink 2.0</b><br>
 */
@interface SDLDeleteFileResponse : SDLRPCResponse

@property (strong, nonatomic) NSNumber<SDLInt> *spaceAvailable;

@end
