//  SDLHMIPermissions.h
//


#import "SDLRPCMessage.h"

#import "SDLHMILevel.h"

/**
 * Defining sets of HMI levels, which are permitted or prohibited for a given RPC.
 * 
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLHMIPermissions : SDLRPCStruct

/**
 * A set of all HMI levels that are permitted for this given RPC
 *
 * @see SDLHMILevel
 *
 * Required, Array of SDLHMILevel, Array size 0 - 100
 */
@property (strong, nonatomic) NSArray<SDLHMILevel> *allowed;

/**
 * A set of all HMI levels that are prohibited for this given RPC
 * 
 * @see SDLHMILevel
 *
 * Required, Array of SDLHMILevel, Array size 0 - 100
 */
@property (strong, nonatomic) NSArray<SDLHMILevel> *userDisallowed;

@end

NS_ASSUME_NONNULL_END
