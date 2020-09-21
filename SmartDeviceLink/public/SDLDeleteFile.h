//  SDLDeleteFile.h
//


#import "SDLRPCRequest.h"

/**
 * Used to delete a file resident on the SDL module in the app's local cache.
 * Not supported on first generation SDL vehicles
 * <p>
 *
 * Since <b>SmartDeviceLink 2.0</b><br>
 * see SDLPutFile SDLListFiles
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteFile : SDLRPCRequest

/// Convenience init to delete a file
///
/// @param fileName A file reference name
/// @return An SDLDeleteFile object
- (instancetype)initWithFileName:(NSString *)fileName;

/**
 * a file reference name
 * @discussion a String value representing a file reference name
 */
@property (strong, nonatomic) NSString *syncFileName;

@end

NS_ASSUME_NONNULL_END
