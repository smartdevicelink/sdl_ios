//
//  RemoteControlManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Beharry, Justin (J.S.) on 8/1/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

#import "RemoteControlManager.h"

#import "AlertManager.h"
#import "SmartDeviceLink.h"

@interface RemoteControlManager()

@property (strong, nonatomic) SDLManager *sdlManager;
@property (strong, nonatomic) NSArray<SDLSoftButtonObject *> *homeButtons;
@property (strong, nonatomic) SDLRemoteControlCapabilities *remoteControlCapabilities;
@property (strong, nonatomic) NSString *climateModuleId;
@property (strong, nonatomic) NSNumber<SDLBool> *hasConsent;
@property (strong, nonatomic) SDLClimateControlData *climateData;
@property (copy, nonatomic, readwrite) NSString *climateDataString;
@property (strong, nonatomic, readonly) NSArray<SDLSoftButtonObject *> *remoteButtons;

@end

@implementation RemoteControlManager

- (instancetype)initWithManager:(SDLManager *)manager softButtons:(NSArray<SDLSoftButtonObject *> *)buttons  {
    self = [super init];
    if (!self) {
        return nil;
    }
    _sdlManager = manager;
    _homeButtons = buttons;
    return self;
}

- (void)start {
    [self.sdlManager.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeRemoteControl withUpdateHandler:^(SDLSystemCapability * _Nullable capability, BOOL subscribed, NSError * _Nullable error) {
        if (!capability.remoteControlCapability) {
            SDLLogE(@"SDL errored getting remote control module information: %@", error);
            return;
        }

        self.remoteControlCapabilities = capability.remoteControlCapability;
        self.climateModuleId = self.remoteControlCapabilities.climateControlCapabilities.firstObject.moduleInfo.moduleId;

        // Get consent to control modules
        SDLGetInteriorVehicleDataConsent *getInteriorVehicleDataConsent = [[SDLGetInteriorVehicleDataConsent alloc] initWithModuleType:SDLModuleTypeClimate moduleIds:@[self.climateModuleId]];
        [self.sdlManager sendRequest:getInteriorVehicleDataConsent withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (!response.success) {
                SDLLogE(@"SDL errored getting remote control consent: %@", error);
                return;
            }
            self.hasConsent = response.success;

            // Initialize climate data and setup subscription
            if (self.hasConsent) {
                [self sdlex_initializeClimateData];
                [self sdlex_subscribeClimateControlData];
            }
        }];
    }];
}

- (void)showClimateControl {
    if (self.climateModuleId == nil && self.hasConsent) {
        NSString *errorMessage = @"The climate module id was not set or consent was not given";
        [AlertManager sendAlertWithManager:self.sdlManager image:nil textField1:errorMessage textField2:nil];
        return;
    }

    // Set the soft buttons to change remote control parameters
    self.sdlManager.screenManager.softButtonObjects = self.remoteButtons;
}

- (NSString *)climateDataString {
    return [NSString stringWithFormat:@"AC: %@\n"
            "AC Max: %@\n"
            "Auto Mode: %@\n"
            "Circulate Air: %@\n"
            "Climate: %@\n"
            "Current Temperature: %@\n"
            "Defrost Zone: %@\n"
            "Desired Temperature: %@\n"
            "Dual Mode: %@\n"
            "Fan Speed: %@\n"
            "Heated Mirrors: %@\n"
            "Heated Rears Window: %@\n"
            "Heated Steering: %@\n"
            "Heated Windshield: %@\n"
            "Ventilation: %@\n",
            self.climateData.acEnable.boolValue ? @"On" : @"Off",
            self.climateData.acMaxEnable.boolValue ? @"On" : @"Off",
            self.climateData.autoModeEnable.boolValue ? @"On" : @"Off",
            self.climateData.circulateAirEnable.boolValue ? @"On" : @"Off",
            self.climateData.climateEnable.boolValue ? @"On" : @"Off",
            self.climateData.currentTemperature,
            self.climateData.defrostZone,
            self.climateData.desiredTemperature,
            self.climateData.dualModeEnable.boolValue ? @"On" : @"Off",
            self.climateData.fanSpeed,
            self.climateData.heatedMirrorsEnable.boolValue ? @"On" : @"Off",
            self.climateData.heatedRearWindowEnable.boolValue ? @"On" : @"Off",
            self.climateData.heatedSteeringWheelEnable.boolValue ? @"On" : @"Off",
            self.climateData.heatedWindshieldEnable.boolValue ? @"On" : @"Off",
            self.climateData.ventilationMode
    ];
}

- (void)sdlex_initializeClimateData {
    if (self.climateModuleId == nil && !self.hasConsent.boolValue) {
        NSString *errorMessage = @"The climate module id was not set or consent was not given";
        [AlertManager sendAlertWithManager:self.sdlManager image:nil textField1:errorMessage textField2:nil];
    }
    
    SDLGetInteriorVehicleData *getInteriorVehicleData = [[SDLGetInteriorVehicleData alloc] initWithModuleType:SDLModuleTypeClimate moduleId:self.climateModuleId];
    [self.sdlManager sendRequest:getInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLGetInteriorVehicleDataResponse *dataResponse = (SDLGetInteriorVehicleDataResponse *)response;
        self.climateData = dataResponse.moduleData.climateControlData;
    }];
}

- (void)sdlex_subscribeClimateControlData {
    // Start the subscription to remote control data
    [self.sdlManager subscribeToRPC:SDLDidReceiveInteriorVehicleDataNotification withBlock:^(__kindof SDLRPCMessage * _Nonnull message) {
        SDLOnInteriorVehicleData *onInteriorVehicleData = (SDLOnInteriorVehicleData *)message;
        self.climateData = onInteriorVehicleData.moduleData.climateControlData;
    }];

    // Start the subscriptin to climate data
    SDLGetInteriorVehicleData *getInteriorVehicleData = [[SDLGetInteriorVehicleData alloc] initAndSubscribeToModuleType:SDLModuleTypeClimate moduleId:self.climateModuleId];
    [self.sdlManager sendRequest:getInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            return SDLLogE(@"SDL errored trying to subscribe to climate data: %@", error);
        }
        SDLLogD(@"SDL Subscribing to climate control data");
    }];
}

- (void)sdlex_turnOnAC {
    SDLClimateControlData *climateControlData = [[SDLClimateControlData alloc] initWithDictionary:@{ @"acEnable": @YES }];
    SDLModuleData *moduleData = [[SDLModuleData alloc] initWithClimateControlData:climateControlData];
    SDLSetInteriorVehicleData *setInteriorVehicleData = [[SDLSetInteriorVehicleData alloc] initWithModuleData:moduleData];

    [self.sdlManager sendRequest:setInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.success) {
            SDLLogE(@"SDL errored trying to turn on climate AC: %@", error);
            return;
        }
    }];
}

- (void)sdlex_turnOffAC {
    SDLClimateControlData *climateControlData = [[SDLClimateControlData alloc] initWithDictionary:@{ @"acEnable": @NO }];
    SDLModuleData *moduleData = [[SDLModuleData alloc] initWithClimateControlData:climateControlData];
    SDLSetInteriorVehicleData *setInteriorVehicleData = [[SDLSetInteriorVehicleData alloc] initWithModuleData:moduleData];

    [self.sdlManager sendRequest:setInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.success) {
            SDLLogE(@"SDL errored trying to turn off climate AC: %@", error);
            return;
        }
    }];
}

- (void)sdlex_setClimateTemperature {
    SDLTemperature *temperature = [[SDLTemperature alloc] initWithFahrenheitValue:73];
    NSDictionary<NSString *, id> *climateDictionary = @{@"acEnable": @YES, @"fanSpeed": @100, @"desiredTemperature": temperature, @"ventilationMode": SDLVentilationModeBoth };

    SDLClimateControlData *climateControlData = [[SDLClimateControlData alloc] initWithDictionary:climateDictionary];
    SDLModuleData *moduleData = [[SDLModuleData alloc] initWithClimateControlData:climateControlData];
    SDLSetInteriorVehicleData *setInteriorVehicleData = [[SDLSetInteriorVehicleData alloc] initWithModuleData:moduleData];

    [self.sdlManager sendRequest:setInteriorVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.success) {
            SDLLogE(@"SDL errored trying to set climate temperature to 73 degrees: %@", error);
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
            if (!response.success) {
                SDLLogE(@"SDL errored toggle AC Max with remote button press: %@", error);
                return;
            }
        }];
    }];

    SDLSoftButtonObject *temperatureDecreaseButton = [[SDLSoftButtonObject alloc] initWithName:@"Temperature Decrease" text:@"Temperature -" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        SDLButtonPress *buttonTouch = [[SDLButtonPress alloc] initWithButtonName:SDLButtonNameTempDown moduleType:SDLModuleTypeClimate moduleId:self.climateModuleId buttonPressMode:SDLButtonPressModeShort];
        [self.sdlManager sendRequest:buttonTouch withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (!response.success) {
                SDLLogE(@"SDL errored decreasing target climate temperature with remote button: %@", error);
                return;
            }
        }];
    }];
    
    SDLSoftButtonObject *temperatureIncreaseButton = [[SDLSoftButtonObject alloc] initWithName:@"Temperature Increase" text:@"Temperature +" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        SDLButtonPress *buttonTouch = [[SDLButtonPress alloc] initWithButtonName:SDLButtonNameTempUp moduleType:SDLModuleTypeClimate moduleId:self.climateModuleId buttonPressMode:SDLButtonPressModeShort];
        [self.sdlManager sendRequest:buttonTouch withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (!response.success) {
                SDLLogE(@"SDL errored increasing target climate temperature with remote button:: %@", error);
                return;
            }
        }];
    }];

    SDLSoftButtonObject *backToHomeButton = [[SDLSoftButtonObject alloc] initWithName:@"Home" text:@"Back to Home" artwork:nil handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        self.sdlManager.screenManager.softButtonObjects = self.homeButtons;
        [self.sdlManager.screenManager changeLayout:[[SDLTemplateConfiguration alloc] initWithPredefinedLayout:SDLPredefinedLayoutNonMedia] withCompletionHandler:nil];
    }];

    return @[acOnButton, acOffButton, acMaxToggle, temperatureDecreaseButton, temperatureIncreaseButton, backToHomeButton];
}

@end
