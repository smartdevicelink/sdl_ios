//  SDLListFilesResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLListFilesResponse is sent, when SDLListFiles has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLListFilesResponse : SDLRPCResponse

@property (strong) NSMutableArray<NSString *> *filenames;
@property (strong) NSNumber<SDLInt> *spaceAvailable;

@end
