//
//  SDLDeleteFileSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteFile.h"
#import "SDLNames.h"

QuickSpecBegin(SDLDeleteFileSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteFile* testRequest = [[SDLDeleteFile alloc] init];
        
		testRequest.syncFileName = @"synchro";

		expect(testRequest.syncFileName).to(equal(@"synchro"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_syncFileName:@"synchro"},
                                             NAMES_operation_name:NAMES_DeleteFile}} mutableCopy];
        SDLDeleteFile* testRequest = [[SDLDeleteFile alloc] initWithDictionary:dict];
        
        expect(testRequest.syncFileName).to(equal(@"synchro"));
    });

    it(@"Should return nil if not set", ^ {
        SDLDeleteFile* testRequest = [[SDLDeleteFile alloc] init];
        
		expect(testRequest.syncFileName).to(beNil());
	});
});

QuickSpecEnd