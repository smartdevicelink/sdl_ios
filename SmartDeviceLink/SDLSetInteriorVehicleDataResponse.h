//
//  SDLSetInteriorVehicleDataResponse.h
//

#import "SDLRPCResponse.h"
@class SDLModuleData;

NS_ASSUME_NONNULL_BEGIN

/**
 Response to SDLSetInteriorVehicleData
 */
@interface SDLSetInteriorVehicleDataResponse : SDLRPCResponse

/**
 The new module data for the requested module

 Optional
 */
@property (nullable, strong, nonatomic) SDLModuleData *moduleData;

@end

NS_ASSUME_NONNULL_END
