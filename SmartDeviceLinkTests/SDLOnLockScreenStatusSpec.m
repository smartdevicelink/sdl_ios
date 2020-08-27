//
//  SDLOnLockScreenStatusSpec.m
//  SmartDeviceLink


#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnLockScreenStatus.h"
#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLOnLockScreenStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    __block bool testDriverDistractionStatus = NO;
    __block int testUserSelected = 3;
    __block SDLLockScreenStatus testLockScreenStatus = SDLLockScreenStatusOptional;
    __block SDLHMILevel testHMILevel = SDLHMILevelBackground;

    it(@"Should set and get correctly", ^ {
        SDLOnLockScreenStatus *testNotification = [[SDLOnLockScreenStatus alloc] init];
        testNotification.driverDistractionStatus = @(testDriverDistractionStatus);
        testNotification.userSelected = @(testUserSelected);
        testNotification.lockScreenStatus = testLockScreenStatus;
        testNotification.hmiLevel = testHMILevel;

        expect(testNotification.driverDistractionStatus).to(beFalse());
        expect(testNotification.userSelected).to(equal(testUserSelected));
        expect(testNotification.lockScreenStatus).to(equal(testLockScreenStatus));
        expect(testNotification.hmiLevel).to(equal(testHMILevel));
    });

    it(@"Should init correctly with initWithDriverDistractionStatus:serSelected:lockScreenStatus:hmiLevel:", ^ {
        SDLOnLockScreenStatus *testNotification = [[SDLOnLockScreenStatus alloc] initWithDriverDistractionStatus:@(testDriverDistractionStatus) userSelected:@(testUserSelected) lockScreenStatus:testLockScreenStatus hmiLevel:testHMILevel];

        expect(testNotification.driverDistractionStatus).to(beFalse());
        expect(testNotification.userSelected).to(equal(testUserSelected));
        expect(testNotification.lockScreenStatus).to(equal(testLockScreenStatus));
        expect(testNotification.hmiLevel).to(equal(testHMILevel));
    });

    it(@"Should return nil if not set", ^ {
        SDLOnLockScreenStatus *testNotification = [[SDLOnLockScreenStatus alloc] init];

        expect(testNotification.driverDistractionStatus).to(beNil());
        expect(testNotification.userSelected).to(beNil());
        expect(testNotification.lockScreenStatus).to(beNil());
        expect(testNotification.hmiLevel).to(beNil());
    });
});

QuickSpecEnd
