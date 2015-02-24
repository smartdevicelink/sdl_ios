//
//  SDLOnEncodedSyncPDataSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/27/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnEncodedSyncPData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnEncodedSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnEncodedSyncPData* testNotification = [[SDLOnEncodedSyncPData alloc] init];
        
        testNotification.data = [@[@0] mutableCopy];
        testNotification.URL = @"www.zombo.com";
        testNotification.Timeout = @564;
        
        expect(testNotification.data).to(equal([@[@0] mutableCopy]));
        expect(testNotification.URL).to(equal(@"www.zombo.com"));
        expect(testNotification.Timeout).to(equal(@564));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_data:[@[@0] mutableCopy],
                                                   NAMES_URL:@"www.zombo.com",
                                                   NAMES_Timeout:@564},
                                             NAMES_operation_name:NAMES_OnEncodedSyncPData}} mutableCopy];
        SDLOnEncodedSyncPData* testNotification = [[SDLOnEncodedSyncPData alloc] initWithDictionary:dict];
        
        expect(testNotification.data).to(equal([@[@0] mutableCopy]));
        expect(testNotification.URL).to(equal(@"www.zombo.com"));
        expect(testNotification.Timeout).to(equal(@564));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnEncodedSyncPData* testNotification = [[SDLOnEncodedSyncPData alloc] init];
        
        expect(testNotification.data).to(beNil());
        expect(testNotification.URL).to(beNil());
        expect(testNotification.Timeout).to(beNil());
    });
});

QuickSpecEnd