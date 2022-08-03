//
//  RemoteControlManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Beharry, Justin (J.S.) on 8/1/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import <SmartDeviceLink/SDLButtonPress.h>
#import <SmartDeviceLink/SDLClimateControlCapabilities.h>
#import <SmartDeviceLink/SDLClimateControlData.h>
#import <SmartDeviceLink/SDLGetInteriorVehicleData.h>
#import <SmartDeviceLink/SDLGetInteriorVehicleDataConsent.h>
#import <SmartDeviceLink/SDLGetInteriorVehicleDataResponse.h>
#import <SmartDeviceLink/SDLLogMacros.h>
#import <SmartDeviceLink/SDLManager.h>
#import <SmartDeviceLink/SDLModuleData.h>
#import <SmartDeviceLink/SDLOnInteriorVehicleData.h>
#import <SmartDeviceLink/SDLRPCResponse.h>
#import <SmartDeviceLink/SDLRemoteControlCapabilities.h>
#import <SmartDeviceLink/SDLScreenManager.h>
#import <SmartDeviceLink/SDLSetInteriorVehicleData.h>
#import <SmartDeviceLink/SDLSoftButtonObject.h>
#import <SmartDeviceLink/SDLSystemCapability.h>
#import <SmartDeviceLink/SDLSystemCapabilityManager.h>
#import <SmartDeviceLink/SDLTemperature.h>
#import "AlertManager.h"
#import "RemoteControlManager.h"

@interface RemoteControlManager()

@property (strong, nonatomic) SDLManager *sdlManager;
@property (strong, nonatomic) SDLRemoteControlCapabilities *remoteControlCapabilities;
@property (strong, nonatomic) NSString *climateModuleId;
@property (strong, nonatomic) NSNumber<SDLBool> *hasConsent;
@property (strong, nonatomic) SDLClimateControlData *climateData;
@property (copy, nonatomic, readwrite) NSString *climateDataString;
@property (strong, nonatomic, readonly) NSArray<SDLSoftButtonObject *> *remoteButtons;

@end

@implementation RemoteControlManager

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (!self) {
        return nil;
    }
    _sdlManager = manager;
    return self;
}

- (void)start {
    [self.sdlManager.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeRemoteControl withUpdateHandler:^(SDLSystemCapability * _Nullable capability, BOOL subscribed, NSError * _Nullable error) {
        if (!capability.remoteControlCapability) {
            SDLLogE(@"SDL errored getting remote control module information: %@", error);
            return;
        }

        self->_remoteControlCapabilities = capability.remoteControlCapability;
        self->_climateModuleId = self.remoteControlCapabilities.climateControlCapabilities.firstObject.moduleInfo.moduleId;

        /// Get consent to control modules
        SDLGetInteriorVehicleDataConsent *getInteriorVehicleDataConsent = [[SDLGetInteriorVehicleDataConsent alloc] initWithModuleType:SDLModuleTypeClimate moduleIds:@[self.climateModuleId]];
        [self.sdlManager sendRequest:getInteriorVehicleDataConsent withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (!response.success) {
                SDLLogE(@"SDL errored getting interior vehicle data consent: %@", error);
                return;
            }
            self->_hasConsent = response.success;

            /// Initialize climate data and setup subscription
            if (self.hasConsent) {
                [self sdlex_initializeClimateData];
                [self sdlex_subscribeVehicleData];
                [self sdlex_subscribeClimateControlData];
            }
        }];
    }];
}

- (void)showClimateControl {
    if (self.climateModuleId == NULL && self.hasConsent) {
        NSString *errorMessage = @"The climate module id was not set or consent was not given";
        [AlertManager sendAlertWithManager:self.sdlManager image:nil textField1:errorMessage textField2:nil];
    }
    self.sdlManager.screenManager.softButtonObjects = self.remoteButtons;
}

- (NSString *)climateDataString {
    return [NSString stringWithFormat:@"AC Enable %@\n"
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
            self.climateData.acEnable.boolValue ? @"On" : @"Off",
            self.climateData.acMaxEnable.boolValue ? @"On" : @"Off",
            self.climateData.autoModeEnable.boolValue ? @"On" : @"Off",
            self.climateData.circulateAirEnable.boolValue ? @"On" : @"Off",
            self.climateData.climateEnable.boolValue ? @"On" : @"Off",
            self.climateData.currentTemperature.description,
            self.climateData.defrostZone.description,
            self.climateData.desiredTemperature.description,
            self.climateData.dualModeEnable.boolValue ? @"On" : @"Off",
            self.climateData.heatedMirrorsEnable.boolValue ? @"On" : @"Off",
            self.climateData.heatedRearWindowEnable.boolValue ? @"On" : @"Off",
            self.climateData.heatedSteeringWheelEnable.boolValue ? @"On" : @"Off",
            self.climateData.heatedWindshieldEnable.boolValue ? @"On" : @"Off",
            self.climateData.ventilationMode.description
    ];
}

- (void)sdlex_initializeClimateData {
    if (self.climateModuleId == NULL && self.hasConsent == 0) {
        NSString *errorMessage = @"The climate module id was not set or consent was not given";
        [AlertManager sendAlertWithManager:self.sdlManager image:nil textField1:errorMessage textField2:nil];
    }
    
    SDLGetInteriorVehicleData *getInteriorVehicleData = [[SDLGetInteriorVehicleData alloc] initWithModuleType:SDLModuleTypeClimate moduleId:self.climateModuleId];
    [self.sdlManager sendRequest:getInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLGetInteriorVehicleDataResponse *dataResponse = (SDLGetInteriorVehicleDataResponse *)response;
        self->_climateData = dataResponse.moduleData.climateControlData;
    }];
}

- (void)sdlex_subscribeVehicleData {
    [self.sdlManager subscribeToRPC:SDLDidReceiveInteriorVehicleDataNotification withBlock:^(__kindof SDLRPCMessage * _Nonnull message) {
        SDLOnInteriorVehicleData *onInteriorVehicleData = (SDLOnInteriorVehicleData *)message;
        if (onInteriorVehicleData == nil) {
            SDLLogE(@"SDL onInteriorVehicleData was set to NULL when trying to subscribe to vehicle data");
            return;
        }
        self.climateData = onInteriorVehicleData.moduleData.climateControlData;
    }];
}

- (void)sdlex_subscribeClimateControlData {
    SDLGetInteriorVehicleData *getInteriorVehicleData = [[SDLGetInteriorVehicleData alloc] initAndSubscribeToModuleType:SDLModuleTypeClimate moduleId:self.climateModuleId];
    [self.sdlManager sendRequest:getInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"SDL errored trying to subscribe to climate data: %@", error);
        }
        SDLLogD(@"SDL Subscribing to Climate Control Data. Data should appear in SDLDidReceiveInteriorVehicleDataNotification");
    }];
}

- (void)sdlex_turnOnAC {
    SDLClimateControlData *climateControlData = [[SDLClimateControlData alloc] initWithDictionary:@{ @"acEnable": @YES }];
    SDLModuleData *moduleData = [[SDLModuleData alloc] initWithClimateControlData:climateControlData];
    SDLSetInteriorVehicleData *setInteriorVehicleData = [[SDLSetInteriorVehicleData alloc] initWithModuleData:moduleData];

    [self.sdlManager sendRequest:setInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if(!response.success) {
            SDLLogE(@"SDL errored trying to set interior vehicle data: %@", error);
            return;
        }
    }];
}

- (void)sdlex_turnOffAC {
    SDLClimateControlData *climateControlData = [[SDLClimateControlData alloc] initWithDictionary:@{ @"acEnable": @NO }];
    SDLModuleData *moduleData = [[SDLModuleData alloc] initWithClimateControlData:climateControlData];
    SDLSetInteriorVehicleData *setInteriorVehicleData = [[SDLSetInteriorVehicleData alloc] initWithModuleData:moduleData];

    [self.sdlManager sendRequest:setInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if(!response.success) {
            SDLLogE(@"SDL errored trying to set interior vehicle data: %@", error);
            return;
        }
    }];
}

- (void)sdlex_setClimate {
    SDLTemperature *temperature = [[SDLTemperature alloc] initWithFahrenheitValue:73];
    NSDictionary<NSString *, id> *climateDictionary = @{@"acEnable": @YES, @"fanSpeed": @100, @"desiredTemperature": temperature, @"ventilationMode": SDLVentilationModeBoth };

    SDLClimateControlData *climateControlData = [[SDLClimateControlData alloc] initWithDictionary:climateDictionary];
    SDLModuleData *moduleData = [[SDLModuleData alloc] initWithClimateControlData:climateControlData];
    SDLSetInteriorVehicleData *setInteriorVehicleData = [[SDLSetInteriorVehicleData alloc] initWithModuleData:moduleData];

    [self.sdlManager sendRequest:setInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if(!response.success) {
            SDLLogE(@"SDL errored trying to set interior vehicle data: %@", error);
            return;
        }
    }];
}

- (NSArray *)remoteButtons {
    SDLSoftButtonObject *acOnButton = [[SDLSoftButtonObject alloc] initWithName:@"AC On" text:@"AC On" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        [self sdlex_turnOnAC];
    }];

    SDLSoftButtonObject *acOffButton = [[SDLSoftButtonObject alloc] initWithName:@"AC Off" text:@"AC Off" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        [self sdlex_turnOffAC];
    }];

    SDLSoftButtonObject *acMaxToggle = [[SDLSoftButtonObject alloc] initWithName:@"AC Max" text:@"AC Max" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        SDLButtonPress *buttonTouch = [[SDLButtonPress alloc] initWithButtonName:SDLButtonNameACMax moduleType:SDLModuleTypeClimate moduleId:self.climateModuleId buttonPressMode:SDLButtonPressModeShort];

        [self.sdlManager sendRequest:buttonTouch withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if(!response.success) {
                SDLLogE(@"SDL errored handling remote button: %@", error);
                return;
            }
        }];
    }];

    SDLSoftButtonObject *temperatureDecreaseButton = [[SDLSoftButtonObject alloc] initWithName:@"Temperature Decrease" text:@"Temperature -" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        SDLButtonPress *buttonTouch = [[SDLButtonPress alloc] initWithButtonName:SDLButtonNameTempDown moduleType:SDLModuleTypeClimate moduleId:self.climateModuleId buttonPressMode:SDLButtonPressModeShort];

        [self.sdlManager sendRequest:buttonTouch withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if(!response.success) {
                SDLLogE(@"SDL errored handling remote button: %@", error);
                return;
            }
        }];
    }];
    
    SDLSoftButtonObject *temperatureIncreaseButton = [[SDLSoftButtonObject alloc] initWithName:@"Temperature Increase" text:@"Temperature +" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        SDLButtonPress *buttonTouch = [[SDLButtonPress alloc] initWithButtonName:SDLButtonNameTempUp moduleType:SDLModuleTypeClimate moduleId:self.climateModuleId buttonPressMode:SDLButtonPressModeShort];

        [self.sdlManager sendRequest:buttonTouch withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if(!response.success) {
                SDLLogE(@"SDL errored handling remote button: %@", error);
                return;
            }
        }];
    }];
    
    SDLSoftButtonObject *setClimateButton = [[SDLSoftButtonObject alloc] initWithName:@"Set Climate" text:@"Set Climate" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        [self sdlex_setClimate];
    }];

    return @[acOnButton, acOffButton, acMaxToggle, temperatureDecreaseButton, temperatureIncreaseButton, setClimateButton];
}

@end
