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

#pragma mark - Subscribe Vehicle Data

- (void)subscribeToVehicleOdometer {
    SDLLogD(@"Subscribing to odometer vehicle data");
    SDLSubscribeVehicleData *subscribeToVehicleOdometer = [[SDLSubscribeVehicleData alloc] init];
    subscribeToVehicleOdometer.odometer = @YES;
    [self.sdlManager sendRequest:subscribeToVehicleOdometer withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error || ![response isKindOfClass:SDLGetVehicleDataResponse.class]) {
            SDLLogD(@"Error sending Get Vehicle Data RPC: %@", error);
            return;
        }

        SDLGetVehicleDataResponse* getVehicleDataResponse = (SDLGetVehicleDataResponse *)response;
        SDLResult resultCode = getVehicleDataResponse.resultCode;

        NSMutableString *message = [NSMutableString stringWithFormat:@"%@: ", VehicleDataOdometerName];
        if ([resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogD(@"Subscribed to vehicle odometer data");
            [message appendString:@"Subscribed"];
        } else if ([resultCode isEqualToEnum:SDLResultDisallowed]) {
            SDLLogD(@"Access to vehicle data disallowed");
            [message appendString:@"Disallowed"];
        } else if ([resultCode isEqualToEnum:SDLResultUserDisallowed]) {
            SDLLogD(@"Vehicle user disabled access to vehicle data");
            [message appendString:@"Disabled"];
        } else if ([resultCode isEqualToEnum:SDLResultIgnored]) {
            SDLLogD(@"Already subscribed to odometer data");
            [message appendString:@"Subscribed"];
        } else if ([resultCode isEqualToEnum:SDLResultDataNotAvailable]) {
            SDLLogD(@"You have permission to access to vehicle data, but the vehicle you are connected to did not provide any data");
            [message appendString:@"Unknown"];
        } else {
            SDLLogD(@"Unknown reason for failure to get vehicle data: %@", error != nil ? error.localizedDescription : @"no error message");
            [message appendString:@"Unsubscribed"];
        }

        self.vehicleOdometerData = message;
    }];
}

- (void)unsubscribeToVehicleOdometer {
    SDLUnsubscribeVehicleData *unsubscribeToVehicleOdometer = [[SDLUnsubscribeVehicleData alloc] init];
    unsubscribeToVehicleOdometer.odometer = @YES;
    [self.sdlManager sendRequest:unsubscribeToVehicleOdometer withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.success.boolValue) { return; }
        [self sdlex_resetOdometer];
    }];
}


- (void)vehicleDataNotification:(SDLRPCNotificationNotification *)notification {
    if (![notification.notification isKindOfClass:SDLOnVehicleData.class]) {
        return;
    }

    SDLOnVehicleData *onVehicleData = (SDLOnVehicleData *)notification.notification;
    self.vehicleOdometerData = [NSString stringWithFormat:@"%@ = %@ kph", VehicleDataOdometerName, onVehicleData.odometer];

}

- (void)sdlex_resetOdometer {
    self.vehicleOdometerData = [NSString stringWithFormat:@"%@ = %@ kph", VehicleDataOdometerName, self.vehicleOdometerData];
}

#pragma mark - Get Vehicle Data

+ (void)getVehicleSpeedWithSDLManager:(SDLManager *)manager {
    if (![manager.permissionManager isRPCAllowed:@"GetVehicleData"]) {
        return;
    }
}

+ (void)checkPhoneCallCapability {

}

@end

NS_ASSUME_NONNULL_END
