//  SDLListFilesResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLListFilesResponse is sent, when SDLListFiles has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLListFilesResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSMutableArray *filenames;
@property (strong) NSNumber *spaceAvailable;

@end
