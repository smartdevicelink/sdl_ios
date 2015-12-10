//
//  SDLRemoteControlManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/9/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "RemoteControlManager.h"

#import "ProxyManager.h"
#import "SDLGetInteriorVehicleData.h"
#import "SDLGetInteriorVehicleDataResponse.h"
#import "SDLGetInteriorVehicleDataCapabilities.h"
#import "SDLGetInteriorVehicleDataCapabilitiesResponse.h"
#import "SDLModuleDescription.h"
#import "SDLModuleType.h"
#import "SDLRPCRequestFactory.h"
#import "SDLSetInteriorVehicleData.h"


@implementation RemoteControlManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetInteriorVehicleDataCapabilitiesResponse:) name:NotificationGetInteriorVehicleDataCapabilitiesResponse object:nil];
    
    return self;
}

- (void)test {
    // Start by sending a request for capabilities
    SDLGetInteriorVehicleDataCapabilities *capabilities = [SDLRPCRequestFactory buildGetInteriorVehicleDataCapabilitiesForZone:nil moduleTypes:nil];
    [[ProxyManager sharedManager] sendMessage:capabilities];
}

- (void)onGetInteriorVehicleDataCapabilitiesResponse:(SDLGetInteriorVehicleDataCapabilitiesResponse *)response {
    NSLog(@"Get Interior Vehicle Data Capabilities Response: %@", response);
    for (SDLModuleDescription *module in response.interiorVehicleDataCapabilities) {
        if ([module.moduleType isEqualToEnum:[SDLModuleType CLIMATE]]) {
            SDLGetInteriorVehicleData *getDataMsg = [SDLRPCRequestFactory buildGetInteriorVehicleDataForModule:module subscribe:NO];
            [[ProxyManager sharedManager] sendMessage:getDataMsg];
        }
    }
}

- (void)onGetInteriorVehicleDataResponse:(SDLGetInteriorVehicleDataResponse *)response {
    NSLog(@"Get Interior Vehicle Data Response: %@", response);
}

@end
