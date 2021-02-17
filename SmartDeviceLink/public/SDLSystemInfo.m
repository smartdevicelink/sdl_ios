//
//  SDLSystemInfo.m
//  SmartDeviceLink
//
//  Created by YL on 01.02.2021.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLSystemInfo.h"
#import "SDLVehicleType.h"

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

- (BOOL)isEqual:(id)object {
    if (!object) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    typeof(self) other = object;
    // handle cases where both properties are nil
    return ((self.vehicleType == other.vehicleType) || [self.vehicleType isEqual:other.vehicleType]) &&
            ((self.systemSoftwareVersion == other.systemSoftwareVersion) || [self.systemSoftwareVersion isEqualToString:other.systemSoftwareVersion]) &&
            ((self.systemHardwareVersion == other.systemHardwareVersion) || [self.systemHardwareVersion isEqualToString:other.systemHardwareVersion]);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p> systemSoftwareVersion:%@; systemHardwareVersion:%@; vehicleType:%@", NSStringFromClass(self.class), self, self.systemSoftwareVersion, self.systemHardwareVersion, self.vehicleType];
}

@end
