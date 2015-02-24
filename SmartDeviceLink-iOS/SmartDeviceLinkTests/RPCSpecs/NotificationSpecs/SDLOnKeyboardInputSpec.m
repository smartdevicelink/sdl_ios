//
//  SDLOnKeyboardInputSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/27/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnKeyboardInput.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnKeyboardInputSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnKeyboardInput* testNotification = [[SDLOnKeyboardInput alloc] init];
        
        testNotification.event = [SDLKeyboardEvent ENTRY_SUBMITTED];
        testNotification.data = @"qwertyg";
        
        expect(testNotification.event).to(equal([SDLKeyboardEvent ENTRY_SUBMITTED]));
        expect(testNotification.data).to(equal(@"qwertyg"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_event:[SDLKeyboardEvent ENTRY_SUBMITTED],
                                                   NAMES_data:@"qwertyg"},
                                             NAMES_operation_name:NAMES_OnKeyboardInput}} mutableCopy];
        SDLOnKeyboardInput* testNotification = [[SDLOnKeyboardInput alloc] initWithDictionary:dict];
        
        expect(testNotification.event).to(equal([SDLKeyboardEvent ENTRY_SUBMITTED]));
        expect(testNotification.data).to(equal(@"qwertyg"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnKeyboardInput* testNotification = [[SDLOnKeyboardInput alloc] init];
        
        expect(testNotification.event).to(beNil());
        expect(testNotification.data).to(beNil());
    });
});

QuickSpecEnd