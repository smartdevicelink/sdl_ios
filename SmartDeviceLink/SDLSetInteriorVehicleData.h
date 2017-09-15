//
//  SDLSetInteriorVehicleData.h
//

#import "SDLRPCRequest.h"
@class SDLModuleData;

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
