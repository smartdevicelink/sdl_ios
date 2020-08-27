//
//  SDLOnInteriorVehicleData.h
//

#import "SDLRPCNotification.h"
@class SDLModuleData;

NS_ASSUME_NONNULL_BEGIN

/**
 Notifications when subscribed vehicle data changes.

 See: SDLSubscribeVehicleData
 */
@interface SDLOnInteriorVehicleData : SDLRPCNotification

/**
 The subscribed module data that changed
 */
@property (strong, nonatomic) SDLModuleData *moduleData;

@end

NS_ASSUME_NONNULL_END
