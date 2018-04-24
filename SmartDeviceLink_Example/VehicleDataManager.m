//
//  VehicleDataManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "VehicleDataManager.h"
#import "AppConstants.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface VehicleDataManager ()

@property (strong, nonatomic) SDLManager *sdlManager;
@property (copy, nonatomic) NSString *vehicleOdometerData;

@end

@implementation VehicleDataManager

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sdlManager = manager;
    _vehicleOdometerData = @"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vehicleDataNotification:) name:SDLDidReceiveVehicleDataNotification object:nil];
    [self sdlex_resetOdometer];

    return self;
}

- (void)subscribeToVehicleOdometer {
    SDLLogD(@"Subscribing to odometer vehicle data");

}

- (void)unsubscribeToVehicleOdometer {

}

- (void)sdlex_resetOdometer {
    self.vehicleOdometerData = [NSString stringWithFormat:@"%@ = %@ kph", VehicleDataOdometerName, self.vehicleOdometerData];
}

+ (void)getVehicleSpeed {

}

+ (void)checkPhoneCallCapability {

}

- (void)vehicleDataNotification:(SDLRPCNotificationNotification *)notification {

}

@end

NS_ASSUME_NONNULL_END
