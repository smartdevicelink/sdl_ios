//  SDLListFiles.h
//


#import "SDLRPCRequest.h"

/**
 * Requests the current list of resident filenames for the registered app. Not
 * supported on First generation SDL vehicles
 * <p>
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLListFiles : SDLRPCRequest

@end

NS_ASSUME_NONNULL_END
