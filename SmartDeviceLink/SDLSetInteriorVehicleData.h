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

- (instancetype)initWithModuleData:(SDLModuleData *)moduleData;

/**
 * The module data to set for the requested RC module.
 *
 */
@property (strong, nonatomic) SDLModuleData *moduleData;

@end

NS_ASSUME_NONNULL_END
