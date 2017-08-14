//
//  SDLSetInteriorVehicleDataResponse.h
//

#import "SDLRPCResponse.h"
@class SDLModuleData;

NS_ASSUME_NONNULL_BEGIN

/**
 * Used to set the values of one remote control module
 *
 */
@interface SDLSetInteriorVehicleDataResponse : SDLRPCResponse

@property (strong, nonatomic) SDLModuleData *moduleData;

@end

NS_ASSUME_NONNULL_END
