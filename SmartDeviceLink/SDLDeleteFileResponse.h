//  SDLDeleteFileResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Delete File Response is sent, when DeleteFile has been called
 *
 * Since <b>SmartDeviceLink 2.0</b><br>
 */
@interface SDLDeleteFileResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSNumber *spaceAvailable;

@end
