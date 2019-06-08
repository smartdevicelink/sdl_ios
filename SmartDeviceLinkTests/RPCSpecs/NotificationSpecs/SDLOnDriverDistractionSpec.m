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

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnDriverDistraction *testNotification = [[SDLOnDriverDistraction alloc] init];
        
        testNotification.state = SDLDriverDistractionStateOn;
        testNotification.lockScreenDismissalEnabled = @1;
        
        expect(testNotification.state).to(equal(SDLDriverDistractionStateOn));
        expect(testNotification.lockScreenDismissalEnabled).to(beTrue());
        
        testNotification.lockScreenDismissalEnabled = @0;
        expect(testNotification.lockScreenDismissalEnabled).to(beFalse());
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary *dictOn = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameState:SDLDriverDistractionStateOn,
                                                   SDLRPCParameterNameLockScreenDismissalEnabled: @1},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnDriverDistraction}} mutableCopy];
        SDLOnDriverDistraction* testNotificationOn = [[SDLOnDriverDistraction alloc] initWithDictionary:dictOn];
        
        expect(testNotificationOn.state).to(equal(SDLDriverDistractionStateOn));
        expect(testNotificationOn.lockScreenDismissalEnabled).to(beTrue());
        
        NSMutableDictionary *dictOff = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameState:SDLDriverDistractionStateOff,
                                                   SDLRPCParameterNameLockScreenDismissalEnabled: @0},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnDriverDistraction}} mutableCopy];
        SDLOnDriverDistraction *testNotificationOff = [[SDLOnDriverDistraction alloc] initWithDictionary:dictOff];

        expect(testNotificationOff.state).to(equal(SDLDriverDistractionStateOff));
        expect(testNotificationOff.lockScreenDismissalEnabled).to(beFalse());
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnDriverDistraction *testNotification = [[SDLOnDriverDistraction alloc] init];
        
        expect(testNotification.state).to(beNil());
        expect(testNotification.lockScreenDismissalEnabled).to(beNil());
        expect(testNotification.lockScreenDismissalEnabled).to(beFalsy());
    });
});

QuickSpecEnd
