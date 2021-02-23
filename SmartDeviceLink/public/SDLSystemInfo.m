//
//  SDLSystemInfo.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/23/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLSystemInfo.h"

#import "SDLVehicleType.h"

@interface SDLSystemInfo ()

@property (strong, nonatomic, readwrite, nullable) SDLVehicleType *vehicleType;
@property (strong, nonatomic, readwrite, nullable) NSString *systemSoftwareVersion;
@property (strong, nonatomic, readwrite, nullable) NSString *systemHardwareVersion;

@end

@implementation SDLSystemInfo

- (instancetype)initWithMake:(nullable NSString *)make model:(nullable NSString *)model trim:(nullable NSString *)trim modelYear:(nullable NSString *)modelYear softwareVersion:(nullable NSString *)softwareVersion hardwareVersion:(nullable NSString *)hardwareVersion {
    self = [super init];
    if (!self) { return nil; }

    _vehicleType = [[SDLVehicleType alloc] initWithMake:make model:model modelYear:modelYear trim:trim];
    _systemSoftwareVersion = softwareVersion;
    _systemHardwareVersion = hardwareVersion;

    return self;
}

- (instancetype)initWithVehicleType:(nullable SDLVehicleType *)vehicleType softwareVersion:(nullable NSString *)softwareVersion hardwareVersion:(nullable NSString *)hardwareVersion {
    self = [super init];
    if (!self) { return nil; }

    _vehicleType = vehicleType;
    _systemSoftwareVersion = softwareVersion;
    _systemHardwareVersion = hardwareVersion;

    return self;
}

@end
