//
//  VehicleDataManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"
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
    SDLLogD(@"Checking if app has permission to access vehicle data...");
    if (![manager.permissionManager isRPCAllowed:@"GetVehicleData"]) {
        SDLAlert *warningAlert = [AlertManager alertWithMessageAndCloseButton:@"This app does not have the required permissions to access vehicle data" textField2:nil];
        [manager sendRequest:warningAlert];
        return;
    }

    SDLLogD(@"App has permission to access vehicle data. Requesting vehicle speed data...");
    SDLGetVehicleData *getVehicleSpeed = [[SDLGetVehicleData alloc] init];
    getVehicleSpeed.speed = @YES;
    [manager sendRequest:getVehicleSpeed withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error || ![response isKindOfClass:SDLGetVehicleDataResponse.class]) {
            SDLAlert *alert = [AlertManager alertWithMessageAndCloseButton:@"Something went wrong while getting vehicle speed" textField2:nil];
            [manager sendRequest:alert];
            return;
        }

        SDLGetVehicleDataResponse* getVehicleDataResponse = (SDLGetVehicleDataResponse *)response;
        SDLResult resultCode = getVehicleDataResponse.resultCode;

        NSMutableString *alertMessage = [NSMutableString stringWithFormat:@"%@: ", VehicleDataSpeedName];
        if ([resultCode isEqualToEnum:SDLResultRejected]) {
            SDLLogD(@"The request for vehicle speed was rejected");
            [alertMessage appendString:@"Rejected"];
        } else if ([resultCode isEqualToEnum:SDLResultDisallowed]) {
            SDLLogD(@"This app does not have the required permissions to access vehicle data.");
            [alertMessage appendString:@"Disallowed"];
        } else if ([resultCode isEqualToEnum:SDLResultSuccess]) {
            NSNumber *speed = getVehicleDataResponse.speed;
            if (speed) {
                SDLLogD(@"Request for vehicle speed successful: %f", speed.floatValue);
                [alertMessage appendString:[NSString stringWithFormat:@"%f kph", speed.floatValue]];
            } else {
                SDLLogD(@"Request for vehicle speed successful but no data returned.");
                [alertMessage appendString:@"Unknown"];
            }
        }

        SDLAlert *alert = [AlertManager alertWithMessageAndCloseButton:alertMessage textField2:nil];
        [manager sendRequest:alert];
    }];
}

#pragma mark - Get Phone Calls

+ (void)checkPhoneCallCapabilityWithManager:(SDLManager *)manager {

}

+ (void)sdlex_dialPhoneNumberWithManager:(SDLManager *)manager phoneNumber:(NSString *)phoneNumber {
    SDLDialNumber *dialNumber = [[SDLDialNumber alloc] initWithNumber:phoneNumber];
    [manager sendRequest:dialNumber withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
}

@end

NS_ASSUME_NONNULL_END
