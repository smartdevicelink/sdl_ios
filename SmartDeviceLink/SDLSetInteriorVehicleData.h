//
//  SDLSetInteriorVehicleData.h
//

#import "SDLRPCRequest.h"

@class SDLModuleData;

/**
 * This RPC allows a remote control type mobile application to
 * change the settings of a specific remote control module.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSetInteriorVehicleData : SDLRPCRequest

/// Convenience init to change settings of a module
///
/// @param moduleData A remote control module data object
/// @return An SDLSetInteriorVehicleData object
- (instancetype)initWithModuleData:(SDLModuleData *)moduleData;

/**
 * The module data to set for the requested RC module.
 *
 */
@property (strong, nonatomic) SDLModuleData *moduleData;

@end

NS_ASSUME_NONNULL_END
