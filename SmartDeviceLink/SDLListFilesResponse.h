//  SDLListFilesResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLListFilesResponse is sent, when SDLListFiles has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLListFilesResponse : SDLRPCResponse

@property (nullable, strong, nonatomic) NSArray<NSString *> *filenames;
@property (strong, nonatomic) NSNumber<SDLInt> *spaceAvailable;

@end

NS_ASSUME_NONNULL_END
