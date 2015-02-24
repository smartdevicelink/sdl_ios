//
//  SDLSystemRequestSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemRequest.h"
#import "SDLRequestType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSystemRequestSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSystemRequest* testRequest = [[SDLSystemRequest alloc] init];
        
        testRequest.requestType = [SDLRequestType AUTH_REQUEST];
        testRequest.fileName = @"AnotherFile";
        
        expect(testRequest.requestType).to(equal([SDLRequestType AUTH_REQUEST]));
        expect(testRequest.fileName).to(equal(@"AnotherFile"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_requestType:[SDLRequestType AUTH_REQUEST],
                                                   NAMES_fileName:@"AnotherFile"},
                                             NAMES_operation_name:NAMES_SystemRequest}} mutableCopy];
        SDLSystemRequest* testRequest = [[SDLSystemRequest alloc] initWithDictionary:dict];
        
        expect(testRequest.requestType).to(equal([SDLRequestType AUTH_REQUEST]));
        expect(testRequest.fileName).to(equal(@"AnotherFile"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSystemRequest* testRequest = [[SDLSystemRequest alloc] init];
        
        expect(testRequest.requestType).to(beNil());
        expect(testRequest.fileName).to(beNil());
    });
});

QuickSpecEnd