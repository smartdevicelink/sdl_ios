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
});

QuickSpecEnd
