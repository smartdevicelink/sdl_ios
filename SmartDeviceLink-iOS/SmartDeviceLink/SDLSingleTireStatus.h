//  SDLSingleTireStatus.h
//

#import "SDLRPCMessage.h"

@class SDLComponentVolumeStatus;


/**
 * Tire pressure status of a single tire.
 *
 * @since SmartDeviceLink 2.0
 */
@interface SDLSingleTireStatus : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLSingleTireStatus object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLSingleTireStatus object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The volume status of a single tire
 */
@property (strong) SDLComponentVolumeStatus *status;

@end
