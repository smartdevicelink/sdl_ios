//
//  SDLOnLockScreenStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/27/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

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
        
        testNotification.driverDistractionStatus = [NSNumber numberWithBool:NO];
        testNotification.userSelected = @3;
        testNotification.lockScreenStatus = [SDLLockScreenStatus REQUIRED];
        testNotification.hmiLevel = [SDLHMILevel HMI_NONE];
        
        expect(testNotification.driverDistractionStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testNotification.userSelected).to(equal(@3));
        expect(testNotification.lockScreenStatus).to(equal([SDLLockScreenStatus REQUIRED]));
        expect(testNotification.hmiLevel).to(equal([SDLHMILevel HMI_NONE]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{@"driverdistractionstatus":[NSNumber numberWithBool:NO],
                                                   @"userselected":@3,
                                                   @"OnLockScreenStatus":[SDLLockScreenStatus REQUIRED],
                                                   @"hmilevel":[SDLHMILevel HMI_NONE]},
                                             NAMES_operation_name:@"OnLockScreenStatus"}} mutableCopy];
        SDLOnLockScreenStatus* testNotification = [[SDLOnLockScreenStatus alloc] initWithDictionary:dict];
        
        expect(testNotification.driverDistractionStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testNotification.userSelected).to(equal(@3));
        expect(testNotification.lockScreenStatus).to(equal([SDLLockScreenStatus REQUIRED]));
        expect(testNotification.hmiLevel).to(equal([SDLHMILevel HMI_NONE]));
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