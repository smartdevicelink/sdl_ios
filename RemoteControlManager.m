//
//  RemoteControlManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Beharry, Justin (J.S.) on 8/1/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import "RemoteControlManager.h"
#import "SmartDeviceLink.h"
#import "AlertManager.h"

@interface RemoteControlManager()

@property (strong, nonatomic) SDLManager *sdlManager;
@property (strong, nonatomic) SDLRemoteControlCapabilities *remoteControlCapabilities;
@property (strong, nonatomic) NSString *climateModuleId;
@property (strong, nonatomic) NSNumber<SDLBool> *consent;
@property (strong, nonatomic) SDLClimateControlData* climateData;

- (void)subscribeVehicleData;
- (void)initializeClimateData;
- (void)subscribeClimateControlData;
- (NSArray*)getButtons;

@end

@implementation RemoteControlManager

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sdlManager = manager;
    
    [_sdlManager.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeRemoteControl withUpdateHandler:^(SDLSystemCapability * _Nullable capability, BOOL subscribed, NSError * _Nullable error) {
        if (!capability.remoteControlCapability) { return; }
        
        NSLog(@"Retrieving Remote Control Capabilities");
        self->_remoteControlCapabilities = capability.remoteControlCapability;
        self->_climateModuleId = self->_remoteControlCapabilities.climateControlCapabilities.firstObject.moduleInfo.moduleId;
                
        /// Get consent to control modules
        SDLGetInteriorVehicleDataConsent *getInteriorVehicleDataConsent = [[SDLGetInteriorVehicleDataConsent alloc] initWithModuleType:SDLModuleTypeClimate moduleIds:@[self->_climateModuleId]];
        [self->_sdlManager sendRequest:getInteriorVehicleDataConsent withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (!response.success) { return; }
            
            NSLog(@"Retrieving Consent");
            NSLog(@"Bool Array %@", response.success);
            self->_consent = response.success;
            
            /// Initialize climate data and setup subscription
            if (self->_consent) {
                [self initializeClimateData];
                [self subscribeVehicleData];
                [self subscribeClimateControlData];
            }
        }];
    }];

    return self;
}

- (void)showClimateControl {
    if (_climateModuleId == NULL && _consent) {
        NSString *errorMessage = @"The climate module id was not set or consent was not given";
        [AlertManager sendAlertWithManager:_sdlManager image:nil textField1:errorMessage textField2:nil];
    }
    
    [_sdlManager.screenManager beginUpdates];
    _sdlManager.screenManager.softButtonObjects = [self getButtons];
    [_sdlManager.screenManager endUpdates];
}

- (NSString*)getClimateData {
    NSString *climateString = [NSString stringWithFormat:@"AC Enable %@\n"
                               "AC Max Enabled %@\n"
                               "Auto Mode Enable %@\n"
                               "Circulate Air Enable %@\n"
                               "Climate Enable %@\n"
                               "Current Temperature %@\n"
                               "Defrost Zone %@\n"
                               "Desired Temperature %@\n"
                               "Dual Mode Enable %@\n"
                               "Heated Mirrors Enable %@\n"
                               "Heated Rears Window Enable %@\n"
                               "Heated Steering Enable %@\n"
                               "Heated Windshield Enable %@\n"
                               "Ventilation %@\n",
                               _climateData.acEnable.boolValue ? @"On" : @"Off",
                               _climateData.acMaxEnable.boolValue ? @"On" : @"Off",
                               _climateData.autoModeEnable.boolValue ? @"On" : @"Off",
                               _climateData.circulateAirEnable.boolValue ? @"On" : @"Off",
                               _climateData.climateEnable.boolValue ? @"On" : @"Off",
                               _climateData.currentTemperature.description,
                               _climateData.defrostZone.description,
                               _climateData.desiredTemperature.description,
                               _climateData.dualModeEnable.boolValue ? @"On" : @"Off",
                               _climateData.heatedMirrorsEnable.boolValue ? @"On" : @"Off",
                               _climateData.heatedRearWindowEnable.boolValue ? @"On" : @"Off",
                               _climateData.heatedSteeringWheelEnable.boolValue ? @"On" : @"Off",
                               _climateData.heatedWindshieldEnable.boolValue ? @"On" : @"Off",
                               _climateData.ventilationMode.description
    ];
    return climateString;
}

- (void)initializeClimateData {
    if (_climateModuleId == NULL && _consent == 0) {
        NSString *errorMessage = @"The climate module id was not set or consent was not given";
        [AlertManager sendAlertWithManager:_sdlManager image:nil textField1:errorMessage textField2:nil];
    }
    
    SDLGetInteriorVehicleData *getInteriorVehicleData = [[SDLGetInteriorVehicleData alloc] initWithModuleType:SDLModuleTypeClimate moduleId:_climateModuleId];
    [_sdlManager sendRequest:getInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLGetInteriorVehicleDataResponse *dataResponse = (SDLGetInteriorVehicleDataResponse *)response;
        self->_climateData = dataResponse.moduleData.climateControlData;
    }];
}

- (void)subscribeVehicleData {
    [_sdlManager subscribeToRPC:SDLDidReceiveInteriorVehicleDataNotification withBlock:^(__kindof SDLRPCMessage * _Nonnull message) {
//        SDLRPCNotificationNotification *dataNotification = (SDLRPCNotificationNotification *)message;
        SDLOnInteriorVehicleData *onInteriorVehicleData = (SDLOnInteriorVehicleData *) message;
        if (onInteriorVehicleData == nil) { return; }

        // This block will now be called whenever vehicle data changes
        // NOTE: If you subscribe to multiple modules, all the data will be sent here. You will have to split it out based on `onInteriorVehicleData.moduleData.moduleType` yourself.
        self->_climateData = onInteriorVehicleData.moduleData.climateControlData;
    }];
}

- (void)subscribeClimateControlData {
    SDLGetInteriorVehicleData *getInteriorVehicleData = [[SDLGetInteriorVehicleData alloc] initAndSubscribeToModuleType:SDLModuleTypeClimate moduleId:_climateModuleId];
    [_sdlManager sendRequest:getInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLGetInteriorVehicleDataResponse *dataResponse = (SDLGetInteriorVehicleDataResponse *)response;
    }];
}

- (NSArray*)getButtons {
    SDLSoftButtonObject *acOnButton = [[SDLSoftButtonObject alloc] initWithName:@"AC On" text:@"AC On" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        NSLog(@"Turn AC On");
    }];
    
    SDLSoftButtonObject *acOffButton = [[SDLSoftButtonObject alloc] initWithName:@"AC Off" text:@"AC Off" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        NSLog(@"Turn AC Off");
    }];
    
    SDLSoftButtonObject *acMaxToggle = [[SDLSoftButtonObject alloc] initWithName:@"AC Max" text:@"AC Max" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        NSLog(@"Toggle AC Max");
    }];
    
    SDLSoftButtonObject *temperatureDecreaseButton = [[SDLSoftButtonObject alloc] initWithName:@"Temperature Decrease" text:@"Temperature -" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        NSLog(@"Temperature -");
    }];
    
    SDLSoftButtonObject *temperatureIncreaseButton = [[SDLSoftButtonObject alloc] initWithName:@"Temperature Increase" text:@"Temperature +" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        NSLog(@"Temperature +");
    }];
    
    SDLSoftButtonObject *setClimateButton = [[SDLSoftButtonObject alloc] initWithName:@"Set Climate" text:@"Set Climate" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        NSLog(@"Set Climate");
    }];
    
    return @[acOnButton, acOffButton, acMaxToggle, temperatureDecreaseButton, temperatureIncreaseButton, setClimateButton];
}

@end
