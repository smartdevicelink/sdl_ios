//  SDLListFilesResponse.h
//


#import "SDLRPCResponse.h"

/**
 Response to SDLListFiles

 Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLListFilesResponse : SDLRPCResponse

/**
 An array of all filenames resident on the module for the given registered app. If omitted, then no files currently reside on the system.
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *filenames;

/**
 Provides the total local space available on the module for the registered app.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *spaceAvailable;

@end

NS_ASSUME_NONNULL_END
