//
//  SDLOnTBTClientStateSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/27/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnTBTClientState.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnTBTClientStateSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] init];
        
        testNotification.state = [SDLTBTState ETA_REQUEST];
        
        expect(testNotification.state).to(equal([SDLTBTState ETA_REQUEST]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_state:[SDLTBTState ETA_REQUEST]},
                                             NAMES_operation_name:NAMES_OnTBTClientState}} mutableCopy];
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] initWithDictionary:dict];
        
        expect(testNotification.state).to(equal([SDLTBTState ETA_REQUEST]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnTBTClientState* testNotification = [[SDLOnTBTClientState alloc] init];
        
        expect(testNotification.state).to(beNil());
    });
});

QuickSpecEnd