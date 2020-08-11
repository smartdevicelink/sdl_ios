//
//  VehicleDataManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"
#import "AppConstants.h"
#import "SDLRPCFunctionNames.h"
#import "SmartDeviceLink.h"
#import "TextValidator.h"
#import "VehicleDataManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface VehicleDataManager ()

@property (strong, nonatomic) SDLManager *sdlManager;
@property (copy, nonatomic, readwrite) NSString *vehicleOdometerData;
@property (copy, nonatomic, nullable) RefreshUIHandler refreshUIHandler;

@end

@implementation VehicleDataManager

#pragma mark - Lifecycle

- (instancetype)initWithManager:(SDLManager *)manager refreshUIHandler:(RefreshUIHandler)refreshUIHandler {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sdlManager = manager;
    _refreshUIHandler = refreshUIHandler;
    _vehicleOdometerData = @"";

    [_sdlManager subscribeToRPC:SDLDidReceiveVehicleDataNotification withObserver:self selector:@selector(vehicleDataNotification:)];
    [self sdlex_resetOdometer];

    return self;
}


#pragma mark - Subscribe Vehicle Data

/**
 *  Subscribes to odometer data. You must subscribe to a notification with name `SDLDidReceiveVehicleData` to get the new data when the odometer data changes.
 */
- (void)subscribeToVehicleOdometer {
    SDLLogD(@"Subscribing to odometer vehicle data");
    SDLSubscribeVehicleData *subscribeToVehicleOdometer = [[SDLSubscribeVehicleData alloc] init];
    subscribeToVehicleOdometer.odometer = @YES;
    [self.sdlManager sendRequest:subscribeToVehicleOdometer withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error || ![response isKindOfClass:SDLSubscribeVehicleDataResponse.class]) {
            SDLLogE(@"Error sending Get Vehicle Data RPC: %@", error);
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
            SDLLogE(@"Unknown reason for failure to get vehicle data: %@", error != nil ? error.localizedDescription : @"no error message");
            [message appendString:@"Unsubscribed"];
        }

        self.vehicleOdometerData = message;

        if (!self.refreshUIHandler) { return; }
        self.refreshUIHandler();
    }];
}

/**
 *  Unsubscribes to vehicle odometer data.
 */
- (void)unsubscribeToVehicleOdometer {
    SDLUnsubscribeVehicleData *unsubscribeToVehicleOdometer = [[SDLUnsubscribeVehicleData alloc] init];
    unsubscribeToVehicleOdometer.odometer = @YES;
    [self.sdlManager sendRequest:unsubscribeToVehicleOdometer withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.success.boolValue) { return; }
        [self sdlex_resetOdometer];
    }];
}

/**
 *  Notification containing the updated vehicle data.
 *
 *  @param notification A SDLOnVehicleData notification
 */
- (void)vehicleDataNotification:(SDLRPCNotificationNotification *)notification {
    if (![notification.notification isKindOfClass:SDLOnVehicleData.class]) {
        return;
    }

    SDLOnVehicleData *onVehicleData = (SDLOnVehicleData *)notification.notification;
    self.vehicleOdometerData = [NSString stringWithFormat:@"%@: %@ km", VehicleDataOdometerName, onVehicleData.odometer];

    if (!self.refreshUIHandler) { return; }
    self.refreshUIHandler();
}

/**
 *  Resets the odometer data
 */
- (void)sdlex_resetOdometer {
    self.vehicleOdometerData = [NSString stringWithFormat:@"%@: Unsubscribed", VehicleDataOdometerName];
}

#pragma mark - Get Vehicle Data

/**
 *  Retreives the current vehicle data
 *
 *  @param manager The SDL Manager
 *  @param triggerSource Whether the menu item was selected by voice or touch
 *  @param vehicleDataType The vehicle data to look for
 */
+ (void)getAllVehicleDataWithManager:(SDLManager *)manager triggerSource:(SDLTriggerSource)triggerSource vehicleDataType:(NSString *)vehicleDataType {
    SDLLogD(@"Checking if app has permission to access vehicle data...");
    if (![manager.permissionManager isRPCNameAllowed:SDLRPCFunctionNameGetVehicleData]) {
        [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"This app does not have the required permissions to access vehicle data" textField2:nil iconName:nil]];
        return;
    }

    SDLLogD(@"App has permission to access vehicle data. Requesting vehicle data...");
    
    SDLGetVehicleData *getAllVehicleData = [[SDLGetVehicleData alloc] initWithGps:@YES speed:@YES rpm:@YES instantFuelConsumption:@YES fuelRange:@YES externalTemperature:@YES turnSignal:@YES vin:@YES prndl:@YES tirePressure:@YES odometer:@YES beltStatus:@YES bodyInformation:@YES deviceStatus:@YES driverBraking:@YES wiperStatus:@YES headLampStatus:@YES engineTorque:@YES accPedalPosition:@YES steeringWheelAngle:@YES engineOilLife:@YES electronicParkBrakeStatus:@YES cloudAppVehicleID:@YES eCallInfo:@YES airbagStatus:@YES emergencyEvent:@YES clusterModeStatus:@YES myKey:@YES handsOffSteering:@YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    getAllVehicleData.fuelLevel = @YES;
    getAllVehicleData.fuelLevel_State = @YES;
#pragma clang diagnostic pop

    [manager sendRequest:getAllVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error || ![response isKindOfClass:SDLGetVehicleDataResponse.class]) {
            [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"Something went wrong while getting vehicle data" textField2:nil iconName:nil]];
            return;
        }

        SDLGetVehicleDataResponse *getVehicleDataResponse = (SDLGetVehicleDataResponse *)response;
        SDLResult resultCode = getVehicleDataResponse.resultCode;

        NSString *alertTitle = vehicleDataType;
        NSString *alertMessage = nil;

        if ([resultCode isEqualToEnum:SDLResultRejected]) {
            SDLLogD(@"The request for vehicle data was rejected");
            alertMessage = @"Rejected";
        } else if ([resultCode isEqualToEnum:SDLResultDisallowed]) {
            SDLLogD(@"This app does not have the required permissions to access vehicle data.");
            alertMessage = @"Disallowed";
        } else if ([resultCode isEqualToEnum:SDLResultSuccess] || [resultCode isEqualToEnum:SDLResultDataNotAvailable]) {
            SDLLogD(@"Request for vehicle data successful");
            if (getVehicleDataResponse) {
                alertMessage = [self sdlex_vehicleDataDescription:getVehicleDataResponse vehicleDataType:vehicleDataType];
            } else {
                SDLLogE(@"No vehicle data returned");
                alertMessage = @"No vehicle data returned";
            }
        }

        alertTitle = [TextValidator validateText:alertTitle length:25];
        alertMessage = [TextValidator validateText:alertMessage length:200];

        if ([triggerSource isEqualToEnum:SDLTriggerSourceMenu]) {
            [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:alertTitle textField2:alertMessage iconName:nil]];
        } else {
            NSString *spokenAlert = alertMessage ?: alertTitle;
            [manager sendRequest:[[SDLSpeak alloc] initWithTTS:spokenAlert]];
        }
    }];
}

+ (NSString *)sdlex_vehicleDataDescription:(SDLGetVehicleDataResponse *)vehicleData vehicleDataType:(NSString *)vehicleDataType {
    NSString *vehicleDataDescription = nil;

    if ([vehicleDataType isEqualToString:ACAccelerationPedalPositionMenuName]) {
        vehicleDataDescription = vehicleData.accPedalPosition.description;
    } else if ([vehicleDataType isEqualToString:ACAirbagStatusMenuName]) {
        vehicleDataDescription = vehicleData.airbagStatus.description;
    } else if ([vehicleDataType isEqualToString:ACBeltStatusMenuName]) {
        vehicleDataDescription = vehicleData.beltStatus.description;
    } else if ([vehicleDataType isEqualToString:ACBodyInformationMenuName]) {
        vehicleDataDescription = vehicleData.bodyInformation.description;
    } else if ([vehicleDataType isEqualToString:ACClusterModeStatusMenuName]) {
        vehicleDataDescription = vehicleData.clusterModeStatus.description;
    } else if ([vehicleDataType isEqualToString:ACDeviceStatusMenuName]) {
        vehicleDataDescription = vehicleData.deviceStatus.description;
    } else if ([vehicleDataType isEqualToString:ACDriverBrakingMenuName]) {
        vehicleDataDescription = vehicleData.driverBraking.description;
    } else if ([vehicleDataType isEqualToString:ACECallInfoMenuName]) {
        vehicleDataDescription = vehicleData.eCallInfo.description;
    } else if ([vehicleDataType isEqualToEnum:ACElectronicParkBrakeStatus]) {
        vehicleDataDescription = vehicleData.electronicParkBrakeStatus.description;
    } else if ([vehicleDataType isEqualToString:ACEmergencyEventMenuName]) {
        vehicleDataDescription = vehicleData.emergencyEvent.description;
    } else if ([vehicleDataType isEqualToString:ACEngineOilLifeMenuName]) {
        vehicleDataDescription = vehicleData.engineOilLife.description;
    } else if ([vehicleDataType isEqualToString:ACEngineTorqueMenuName]) {
        vehicleDataDescription = vehicleData.engineTorque.description;
    } else if ([vehicleDataType isEqualToString:ACExternalTemperatureMenuName]) {
        vehicleDataDescription = vehicleData.externalTemperature.description;
    } else if ([vehicleDataType isEqualToString:ACFuelLevelMenuName]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        vehicleDataDescription = vehicleData.fuelLevel.description;
#pragma clang diagnostic pop
    } else if ([vehicleDataType isEqualToString:ACFuelLevelStateMenuName]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        vehicleDataDescription = vehicleData.fuelLevel_State.description;
#pragma clang diagnostic pop
    } else if ([vehicleDataType isEqualToString:ACFuelRangeMenuName]) {
        vehicleDataDescription = vehicleData.fuelRange.description;
    } else if ([vehicleDataType isEqualToString:ACGPSMenuName]) {
        vehicleDataDescription = vehicleData.gps.description;
    } else if ([vehicleDataType isEqualToString:ACHeadLampStatusMenuName]) {
        vehicleDataDescription = vehicleData.headLampStatus.description;
    } else if ([vehicleDataType isEqualToString:ACInstantFuelConsumptionMenuName]) {
        vehicleDataDescription = vehicleData.instantFuelConsumption.description;
    } else if ([vehicleDataType isEqualToString:ACMyKeyMenuName]) {
        vehicleDataDescription = vehicleData.myKey.description;
    } else if ([vehicleDataType isEqualToString:ACOdometerMenuName]) {
        vehicleDataDescription = vehicleData.odometer.description;
    } else if ([vehicleDataType isEqualToString:ACPRNDLMenuName]) {
        vehicleDataDescription = vehicleData.prndl.description;
    } else if ([vehicleDataType isEqualToString:ACSpeedMenuName]) {
        vehicleDataDescription = vehicleData.speed.description;
    } else if ([vehicleDataType isEqualToString:ACSteeringWheelAngleMenuName]) {
        vehicleDataDescription = vehicleData.steeringWheelAngle.description;
    } else if ([vehicleDataType isEqualToString:ACTirePressureMenuName]) {
        vehicleDataDescription = vehicleData.tirePressure.description;
    } else if ([vehicleDataType isEqualToString:ACTurnSignalMenuName]) {
        vehicleDataDescription = vehicleData.turnSignal.description;
    } else if ([vehicleDataType isEqualToString: ACVINMenuName]) {
        vehicleDataDescription = vehicleData.vin.description;
    }

    return vehicleDataDescription ?: @"Vehicle data not available";
}

#pragma mark - Phone Calls

/**
 *  Checks if the head unit has the ability and/or permissions to make a phone call. If it does, the phone number is dialed.
 *
 *  @param manager      The SDL manager
 *  @param phoneNumber  A phone number to dial
 */
+ (void)checkPhoneCallCapabilityWithManager:(SDLManager *)manager phoneNumber:(NSString *)phoneNumber {
    SDLLogD(@"Checking phone call capability");
    [manager.systemCapabilityManager updateCapabilityType:SDLSystemCapabilityTypePhoneCall completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager * _Nonnull systemCapabilityManager) {
        if (!systemCapabilityManager.phoneCapability) {
            [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"The head unit does not support the phone call  capability" textField2:nil iconName:nil]];
            return;
        }

        if (systemCapabilityManager.phoneCapability.dialNumberEnabled.boolValue) {
            SDLLogD(@"Dialing phone number %@", phoneNumber);
            [self sdlex_dialPhoneNumber:phoneNumber manager:manager];
        } else {
            [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"The dial number feature is unavailable for this head unit" textField2:nil iconName:nil]];
        }
    }];
}

/**
 *  Dials a phone number.
 *
 *  @param phoneNumber  A phone number to dial
 *  @param manager      The SDL manager
 */
+ (void)sdlex_dialPhoneNumber:(NSString *)phoneNumber manager:(SDLManager *)manager {
    SDLDialNumber *dialNumber = [[SDLDialNumber alloc] initWithNumber:phoneNumber];
    [manager sendRequest:dialNumber withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.resultCode) { return; }
        SDLLogD(@"Sent dial number request: %@", response.resultCode == SDLResultSuccess ? @"successfully" : @"unsuccessfully");
    }];
}

@end

NS_ASSUME_NONNULL_END
