//
//  SDLGetDTCsSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetDTCs.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetDTCsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetDTCs* testRequest = [[SDLGetDTCs alloc] init];
        
		testRequest.ecuName = @4321;
		testRequest.dtcMask = @22;

		expect(testRequest.ecuName).to(equal(@4321));
		expect(testRequest.dtcMask).to(equal(@22));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_ecuName:@4321,
                                                   NAMES_dtcMask:@22},
                                             NAMES_operation_name:NAMES_EndAudioPassThru}} mutableCopy];
        SDLGetDTCs* testRequest = [[SDLGetDTCs alloc] initWithDictionary:dict];
        
        expect(testRequest.ecuName).to(equal(@4321));
        expect(testRequest.dtcMask).to(equal(@22));
    });

    it(@"Should return nil if not set", ^ {
        SDLGetDTCs* testRequest = [[SDLGetDTCs alloc] init];
        
		expect(testRequest.ecuName).to(beNil());
		expect(testRequest.dtcMask).to(beNil());
	});
});

QuickSpecEnd