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
@interface SDLListFiles : SDLRPCRequest {
}
/**
 * Constructs a new SDLListFiles object
 */
- (instancetype)init;
/**
 * Constructs a new SDLListFiles object indicated by the dictionary parameter
 * <p>
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;
@end
