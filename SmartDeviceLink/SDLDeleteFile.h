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
@interface SDLDeleteFile : SDLRPCRequest {
}

/**
 * Constructs a new SDLDeleteFile object
 */
- (instancetype)init;
/**
 * Constructs a new SDLDeleteFile object indicated by the dictionary parameter
 * <p>
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithFileName:(NSString *)fileName;

/**
 * @abstract a file reference name
 * @discussion a String value representing a file reference name
 */
@property (strong) NSString *syncFileName;

@end
