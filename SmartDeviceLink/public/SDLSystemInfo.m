//
//  SDLSystemInfo.m
//  SmartDeviceLink
//
//  Created by YL on 01.02.2021.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLSystemInfo.h"

@interface SDLSystemInfo ()

@property (strong, nonatomic, readwrite) SDLVehicleType *vehicleType;
@property (strong, nonatomic, readwrite, nullable) NSString *systemSoftwareVersion;
@property (strong, nonatomic, readwrite, nullable) NSString *systemHardwareVersion;

@end

@implementation SDLSystemInfo

- (instancetype)initWithVehicleType:(SDLVehicleType *)vehicleType systemSoftwareVersion:(NSString *__nullable)systemSoftwareVersion systemHardwareVersion:(NSString *__nullable)systemHardwareVersion {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.vehicleType = vehicleType;
    self.systemSoftwareVersion = systemSoftwareVersion;
    self.systemHardwareVersion = systemHardwareVersion;
    return self;
}

@end
