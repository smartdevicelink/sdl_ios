//  SDLImage.h
//

#import "SDLRPCMessage.h"

@class SDLImageType;


/**
 *Specifies, which image shall be used, e.g. in SDLAlerts or on SDLSoftbuttons provided the display supports it.
 * 
 * @since SDL 2.0
 */
@interface SDLImage : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLImage object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLImage object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithName:(NSString *)name ofType:(SDLImageType *)imageType;

/**
 * @abstract The static hex icon value or the binary image file name identifier (sent by SDLPutFile)
 *
 * Required, max length = 65535
 */
@property (strong) NSString *value;

/**
 * @abstract Describes, whether it is a static or dynamic image
 *
 * Required
 */
@property (strong) SDLImageType *imageType;

@end
