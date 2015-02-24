//
//  SDLDiagnosticMessageResponseSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDiagnosticMessageResponse.h"
#import "SDLNames.h"

QuickSpecBegin(SDLDiagnosticMessageResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDiagnosticMessageResponse* testResponse = [[SDLDiagnosticMessageResponse alloc] init];
        
        testResponse.messageDataResult = [@[@3, @9, @27, @81] mutableCopy];
        
        expect(testResponse.messageDataResult).to(equal([@[@3, @9, @27, @81] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                           @{NAMES_parameters:
                                                 @{NAMES_messageDataResult:[@[@3, @9, @27, @81] mutableCopy]},
                                             NAMES_operation_name:NAMES_DiagnosticMessage}} mutableCopy];
        SDLDiagnosticMessageResponse* testResponse = [[SDLDiagnosticMessageResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.messageDataResult).to(equal([@[@3, @9, @27, @81] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDiagnosticMessageResponse* testResponse = [[SDLDiagnosticMessageResponse alloc] init];
        
        expect(testResponse.messageDataResult).to(beNil());
    });
});

QuickSpecEnd