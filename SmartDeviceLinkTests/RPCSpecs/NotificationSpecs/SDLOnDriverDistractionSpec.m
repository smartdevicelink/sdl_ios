//
//  SDLOnDriverDistractionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDriverDistractionState.h"
#import "SDLOnDriverDistraction.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLOnDriverDistractionSpec)

NSString *testDismissalWarning = @"I got an apple.";

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnDriverDistraction *testNotification = [[SDLOnDriverDistraction alloc] init];
        
        testNotification.state = SDLDriverDistractionStateOn;
        testNotification.lockScreenDismissalEnabled = @1;
        testNotification.lockScreenDismissalWarning = testDismissalWarning;

        expect(testNotification.state).to(equal(SDLDriverDistractionStateOn));
        expect(testNotification.lockScreenDismissalEnabled).to(beTrue());
        expect(testNotification.lockScreenDismissalWarning).to(equal(testDismissalWarning));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dictOn = @{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameState:SDLDriverDistractionStateOn,
                                                   SDLRPCParameterNameLockScreenDismissalEnabled: @1,
                                                   SDLRPCParameterNameLockScreenDismissalWarning: testDismissalWarning},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnDriverDistraction}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

        SDLOnDriverDistraction* testNotificationOn = [[SDLOnDriverDistraction alloc] initWithDictionary:dictOn];
        
        expect(testNotificationOn.state).to(equal(SDLDriverDistractionStateOn));
        expect(testNotificationOn.lockScreenDismissalEnabled).to(beTrue());
        expect(testNotificationOn.lockScreenDismissalWarning).to(equal(testDismissalWarning));
        
        NSDictionary *dictOff = @{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameState:SDLDriverDistractionStateOff,
                                                   SDLRPCParameterNameLockScreenDismissalEnabled: @0},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnDriverDistraction}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnDriverDistraction *testNotificationOff = [[SDLOnDriverDistraction alloc] initWithDictionary:dictOff];

        expect(testNotificationOff.state).to(equal(SDLDriverDistractionStateOff));
        expect(testNotificationOff.lockScreenDismissalEnabled).to(beFalse());
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnDriverDistraction *testNotification = [[SDLOnDriverDistraction alloc] init];
        
        expect(testNotification.state).to(beNil());
        expect(testNotification.lockScreenDismissalWarning).to(beNil());
        expect(testNotification.lockScreenDismissalEnabled).to(beNil());
        expect(testNotification.lockScreenDismissalEnabled).to(beFalsy());
    });
});

QuickSpecEnd
