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
@interface SDLSetAppIcon : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLSetAppIcon object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSetAppIcon object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithFileName:(NSString *)fileName;


/**
 * @abstract A file reference name
 * @discussion A String value representing a file reference name
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (strong) NSString *syncFileName;

@end
