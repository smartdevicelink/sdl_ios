//
//  SDLOnSyncPDataSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/27/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnSyncPData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] init];
        
        testNotification.URL = @"https://www.youtube.com/watch?v=ygr5AHufBN4";
        testNotification.Timeout = @8357;
        
        expect(testNotification.URL).to(equal(@"https://www.youtube.com/watch?v=ygr5AHufBN4"));
        expect(testNotification.Timeout).to(equal(@8357));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_URL:@"https://www.youtube.com/watch?v=ygr5AHufBN4",
                                                   NAMES_Timeout:@8357},
                                             NAMES_operation_name:NAMES_OnSyncPData}} mutableCopy];
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] initWithDictionary:dict];
        
        expect(testNotification.URL).to(equal(@"https://www.youtube.com/watch?v=ygr5AHufBN4"));
        expect(testNotification.Timeout).to(equal(@8357));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] init];
        
        expect(testNotification.URL).to(beNil());
        expect(testNotification.Timeout).to(beNil());
    });
});

QuickSpecEnd