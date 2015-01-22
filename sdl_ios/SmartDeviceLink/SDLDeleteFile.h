//  SDLDeleteFile.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

/**
 * Used to delete a file resident on the SDL module in the app's local cache.
 * Not supported on first generation SDL vehicles
 * <p>
 *
 * Since <b>SmartDeviceLink 2.0</b><br>
 * see SDLPutFile SDLListFiles
 */
@interface SDLDeleteFile : SDLRPCRequest {}

/**
 * Constructs a new SDLDeleteFile object
 */
-(id) init;
/**
 * Constructs a new SDLDeleteFile object indicated by the NSMutableDictionary parameter
 * <p>
 *
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract a file reference name
 * @discussion a String value representing a file reference name
 */
@property(strong) NSString* syncFileName;

@end
