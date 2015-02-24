//
//  SDLEncodedSyncPDataSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEncodedSyncPData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLEncodedSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
        
		testRequest.data = [@[@2, @2, @2] mutableCopy];

		expect(testRequest.data).to(equal([@[@2, @2, @2] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_data:[@[@2, @2, @2] mutableCopy]},
                                             NAMES_operation_name:NAMES_EncodedSyncPData}} mutableCopy];
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] initWithDictionary:dict];
        
        expect(testRequest.data).to(equal([@[@2, @2, @2] mutableCopy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLEncodedSyncPData* testRequest = [[SDLEncodedSyncPData alloc] init];
        
		expect(testRequest.data).to(beNil());
	});
});

QuickSpecEnd