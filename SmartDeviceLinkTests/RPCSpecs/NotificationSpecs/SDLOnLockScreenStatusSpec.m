//
//  SDLOnLockScreenStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnLockScreenStatus.h"
#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnLockScreenStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnLockScreenStatus* testNotification = [[SDLOnLockScreenStatus alloc] init];
        
        testNotification.driverDistractionStatus = @NO;
        testNotification.userSelected = @3;
        testNotification.lockScreenStatus = SDLLockScreenStatusRequired;
        testNotification.hmiLevel = SDLHMILevelNone;
        
        expect(testNotification.driverDistractionStatus).to(equal(@NO));
        expect(testNotification.userSelected).to(equal(@3));
        expect(testNotification.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
        expect(testNotification.hmiLevel).to(equal(SDLHMILevelNone));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{@"driverDistractionStatus":@NO,
                                                   @"userSelected":@3,
                                                   @"OnLockScreenStatus":SDLLockScreenStatusRequired,
                                                   @"hmiLevel":SDLHMILevelNone},
                                             SDLNameOperationName:@"OnLockScreenStatus"}} mutableCopy];
        SDLOnLockScreenStatus* testNotification = [[SDLOnLockScreenStatus alloc] initWithDictionary:dict];
        
        expect(testNotification.driverDistractionStatus).to(equal(@NO));
        expect(testNotification.userSelected).to(equal(@3));
        expect(testNotification.lockScreenStatus).to(equal(SDLLockScreenStatusRequired));
        expect(testNotification.hmiLevel).to(equal(SDLHMILevelNone));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnLockScreenStatus* testNotification = [[SDLOnLockScreenStatus alloc] init];
        
        expect(testNotification.driverDistractionStatus).to(beNil());
        expect(testNotification.userSelected).to(beNil());
        expect(testNotification.lockScreenStatus).to(beNil());
        expect(testNotification.hmiLevel).to(beNil());
    });
});

QuickSpecEnd
