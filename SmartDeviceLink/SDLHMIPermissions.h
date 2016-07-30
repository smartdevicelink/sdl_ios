//  SDLHMIPermissions.h
//


#import "SDLRPCMessage.h"

/**
 * Defining sets of HMI levels, which are permitted or prohibited for a given RPC.
 * 
 * @since SDL 2.0
 */
@interface SDLHMIPermissions : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLHMIPermissions object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLHMIPermissions object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract a set of all HMI levels that are permitted for this given RPC
 *
 * @see SDLHMILevel
 *
 * Required, Array of SDLHMILevel, Array size 0 - 100
 */
@property (strong) NSMutableArray *allowed;

/**
 * @abstract a set of all HMI levels that are prohibited for this given RPC
 * 
 * @see SDLHMILevel
 *
 * Required, Array of SDLHMILevel, Array size 0 - 100
 */
@property (strong) NSMutableArray *userDisallowed;

@end
