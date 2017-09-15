//
//  SDLOnInteriorVehicleData.h
//

#import "SDLRPCNotification.h"
@class SDLModuleData;

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnInteriorVehicleData : SDLRPCNotification

@property (strong, nonatomic) SDLModuleData *moduleData;

@end

NS_ASSUME_NONNULL_END
