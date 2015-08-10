//  SDLParameterPermissions.h
//


#import "SDLRPCMessage.h"

/**
 * Defining sets of parameters, which are permitted or prohibited for a given RPC.
 *
 * @since SDL 2.0
 */
@interface SDLParameterPermissions : SDLRPCStruct {
}

/**
 * @abstract  Constructs a newly allocated SDLParameterPermissions object
 */
- (instancetype)init;
/**
 * @abstract Constructs a newly allocated SDLParameterPermissions object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract A set of all parameters that are permitted for this given RPC.
 *
 * Required, Array of String, max String length = 100, Array size 0 - 100
 */
@property (strong) NSMutableArray *allowed;
/**
 * @abstract A set of all parameters that are prohibited for this given RPC.
 *
 * Required, Array of String, max String length = 100, Array size 0 - 100
 */
@property (strong) NSMutableArray *userDisallowed;

@end
