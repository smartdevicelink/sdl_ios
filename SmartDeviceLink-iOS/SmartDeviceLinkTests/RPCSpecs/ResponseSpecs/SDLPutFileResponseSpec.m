//
//  SDLPutFileResponseSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPutFileResponse.h"
#import "SDLNames.h"

QuickSpecBegin(SDLPutFileResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPutFileResponse* testResponse = [[SDLPutFileResponse alloc] init];
        
        testResponse.spaceAvailable = @1248;
        
        expect(testResponse.spaceAvailable).to(equal(@1248));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                           @{NAMES_parameters:
                                                 @{NAMES_spaceAvailable:@1248},
                                             NAMES_operation_name:NAMES_PutFile}} mutableCopy];
        SDLPutFileResponse* testResponse = [[SDLPutFileResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.spaceAvailable).to(equal(@1248));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPutFileResponse* testResponse = [[SDLPutFileResponse alloc] init];
        
        expect(testResponse.spaceAvailable).to(beNil());
    });
});

QuickSpecEnd