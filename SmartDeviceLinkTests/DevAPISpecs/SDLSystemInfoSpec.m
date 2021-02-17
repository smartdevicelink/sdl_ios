#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemInfo.h"
#import "SDLVehicleType.h"

QuickSpecBegin(SDLSystemInfoSpec)

NSString *hardVersion = @"1.2.3";
NSString *softVersion = @"9.8.7";
SDLVehicleType *vehicleType = [[SDLVehicleType alloc] init];

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

    context(@"initWithVehicleType:systemSoftwareVersion:systemHardwareVersion:", ^{
        beforeEach(^{
            systemInfo = [[SDLSystemInfo alloc] initWithVehicleType:vehicleType systemSoftwareVersion:softVersion systemHardwareVersion:hardVersion];
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
            expect(systemInfo).notTo(beNil());
            SDLSystemInfo *systemInfo2 = [systemInfo init];
            expect(systemInfo2).notTo(beNil());
            expect(systemInfo2).to(equal(systemInfo));
        });
    });

    context(@"isEqual:", ^{
        __block SDLSystemInfo *systemInfo2 = nil;
        __block SDLSystemInfo *systemInfo3 = nil;
        beforeEach(^{
            systemInfo = [[SDLSystemInfo alloc] initWithVehicleType:vehicleType systemSoftwareVersion:softVersion systemHardwareVersion:hardVersion];
            systemInfo2 = [[SDLSystemInfo alloc] init];
            systemInfo3 = [[SDLSystemInfo alloc] initWithVehicleType:vehicleType systemSoftwareVersion:softVersion systemHardwareVersion:hardVersion];
        });

        it(@"expect test objects to come into existance", ^{
            expect(systemInfo).notTo(beNil());
            expect(systemInfo2).notTo(beNil());
        });

        it(@"expect proper comparison result", ^{
            BOOL equal = [systemInfo isEqual:nil];
            expect(equal).to(beFalse());
            equal = [systemInfo isEqual:@"wrong-type-object"];
            expect(equal).to(beFalse());
            equal = [systemInfo isEqual:systemInfo];
            expect(equal).to(beTrue());
            equal = [systemInfo isEqual:systemInfo2];
            expect(equal).to(beFalse());
            equal = [systemInfo isEqual:systemInfo3];
            expect(equal).to(beTrue());
        });
    });
});

QuickSpecEnd
