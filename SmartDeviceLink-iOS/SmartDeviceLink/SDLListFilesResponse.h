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

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSMutableArray *filenames;
@property (strong) NSNumber *spaceAvailable;

@end
