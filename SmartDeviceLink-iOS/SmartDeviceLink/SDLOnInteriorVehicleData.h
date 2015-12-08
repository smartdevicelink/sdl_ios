//
//  SDLOnInteriorVehicleData.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCNotification.h"

@class SDLModuleData;


NS_ASSUME_NONNULL_BEGIN

@interface SDLOnInteriorVehicleData : SDLRPCNotification

@property (strong, nonatomic) SDLModuleData *moduleData;

@end

NS_ASSUME_NONNULL_END
