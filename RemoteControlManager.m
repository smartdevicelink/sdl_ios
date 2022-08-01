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
        [self.sdlManager sendRequest:getInteriorVehicleDataConsent withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (!response.success) { return; }
            
            NSLog(@"Retrieving Consent");
            NSLog(@"Bool Array %@", response.success);
            self->_consent = response.success;
        }];
    }];

    return self;
}

- (void)showClimateControl {
    if (_climateModuleId == NULL && _consent == 0) {
        NSString *errorMessage = @"The climate module id was not set or consent was not given";
        [AlertManager sendAlertWithManager:_sdlManager image:nil textField1:errorMessage textField2:nil];
    }
    
    [_sdlManager.screenManager beginUpdates];
    _sdlManager.screenManager.softButtonObjects = [self getButtons];
    [_sdlManager.screenManager endUpdates];
}

- (NSString*)getClimateData {
    NSString* helloWorld = _climateModuleId;
    return helloWorld;
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
