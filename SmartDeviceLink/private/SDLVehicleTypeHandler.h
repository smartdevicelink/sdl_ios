//
//  SDLProtocolDelegateHandler.h
//  SmartDeviceLink
//
//  Created by YL on 01/12/21.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLVehicleType;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLVehicleTypeHandler <NSObject>

- (BOOL)shouldProceedWithVehicleType:(SDLVehicleType *)vehicleType;

- (void)doDisconnectWithVehicleType:(SDLVehicleType *)vehicleType;

@end

NS_ASSUME_NONNULL_END
