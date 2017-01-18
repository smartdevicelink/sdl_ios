//  SDLListFilesResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLListFilesResponse is sent, when SDLListFiles has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLListFilesResponse : SDLRPCResponse

@property (strong, nonatomic) NSMutableArray<NSString *> *filenames;
@property (strong, nonatomic) NSNumber<SDLInt> *spaceAvailable;

@end
