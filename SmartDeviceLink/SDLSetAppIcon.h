//  SDLSetAppIcon.h
//


#import "SDLRPCRequest.h"

/**
 * Used to set existing local file on SDL as the app's icon. Not supported on
 * first generation SDL modules.
 * <p>
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSetAppIcon : SDLRPCRequest

/// Convenience init to set an image icon from a file name. The file must already be uploaded to the head unit.
///
/// @param fileName A file reference name
/// @return An SDLSetAppIcon object
- (instancetype)initWithFileName:(NSString *)fileName;

/**
 * A file reference name
 * @discussion A String value representing a file reference name
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (strong, nonatomic) NSString *syncFileName;

@end

NS_ASSUME_NONNULL_END
