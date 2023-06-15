//
//  SDLSystemInfoSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/24/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLSystemInfo.h"
#import "SDLVehicleType.h"

QuickSpecBegin(SDLSystemInfoSpec)

NSString *hardVersion = @"1.2.3";
NSString *softVersion = @"9.8.7";
NSString *make = @"Make";
NSString *model = @"model";
NSString *trim = @"trim";
NSString *modelYear = @"2021";
SDLVehicleType *vehicleType = [[SDLVehicleType alloc] initWithMake:make model:model modelYear:modelYear trim:trim];

describe(@"system info", ^{
    __block SDLSystemInfo *systemInfo = nil;

    context(@"init", ^{
        beforeEach(^{
            systemInfo = [[SDLSystemInfo alloc] init];
        });

        it(@"expect all properties to be nil", ^{
            expect(systemInfo).notTo(beNil());
            expect(systemInfo.vehicleType).to(beNil());
            expect(systemInfo.systemSoftwareVersion).to(beNil());
            expect(systemInfo.systemHardwareVersion).to(beNil());
        });
    });

    context(@"initWithMake:model:trim:modelYear:softwareVersion:hardwareVersion:", ^{
        beforeEach(^{
            systemInfo = [[SDLSystemInfo alloc] initWithMake:make model:model trim:trim modelYear:modelYear softwareVersion:softVersion hardwareVersion:hardVersion];
        });

        it(@"expect all properties to be set properly", ^{
            expect(systemInfo).notTo(beNil());
            expect(systemInfo.vehicleType.make).to(equal(make));
            expect(systemInfo.vehicleType.model).to(equal(model));
            expect(systemInfo.vehicleType.trim).to(equal(trim));
            expect(systemInfo.vehicleType.modelYear).to(equal(modelYear));
            expect(systemInfo.systemSoftwareVersion).to(equal(softVersion));
            expect(systemInfo.systemHardwareVersion).to(equal(hardVersion));
        });
    });

    context(@"initWithVehicleType:systemSoftwareVersion:systemHardwareVersion:", ^{
        beforeEach(^{
            systemInfo = [[SDLSystemInfo alloc] initWithVehicleType:vehicleType softwareVersion:softVersion hardwareVersion:hardVersion];
        });

        it(@"expect all properties to be set properly", ^{
            expect(systemInfo).notTo(beNil());
            expect(systemInfo.vehicleType).to(equal(vehicleType));
            expect(systemInfo.systemSoftwareVersion).to(equal(softVersion));
            expect(systemInfo.systemHardwareVersion).to(equal(hardVersion));
        });
    });

    context(@"alloc and init", ^{
        beforeEach(^{
            systemInfo = [SDLSystemInfo alloc];
        });

        it(@"expect test object to be inited", ^{
            expect(systemInfo.vehicleType).to(beNil());
            expect(systemInfo.systemHardwareVersion).to(beNil());
            expect(systemInfo.systemSoftwareVersion).to(beNil());
        });
    });
});

QuickSpecEnd
