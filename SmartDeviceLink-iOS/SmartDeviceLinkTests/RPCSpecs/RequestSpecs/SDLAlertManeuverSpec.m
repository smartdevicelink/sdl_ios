//
//  SDLAlertManeuverSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlertManeuver.h"
#import "SDLTTSChunk.h"
#import "SDLSoftButton.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAlertManeuverSpec)

SDLTTSChunk* tts = [[SDLTTSChunk alloc] init];
SDLSoftButton* button = [[SDLSoftButton alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAlertManeuver* testRequest = [[SDLAlertManeuver alloc] init];
        
        testRequest.ttsChunks = [@[tts] mutableCopy];
        testRequest.softButtons = [@[button] mutableCopy];
        
        expect(testRequest.ttsChunks).to(equal([@[tts] mutableCopy]));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_ttsChunks:[@[tts] mutableCopy],
                                                   NAMES_softButtons:[@[button] mutableCopy]},
                                             NAMES_operation_name:NAMES_AlertManeuver}} mutableCopy];
        SDLAlertManeuver* testRequest = [[SDLAlertManeuver alloc] initWithDictionary:dict];
        
        expect(testRequest.ttsChunks).to(equal([@[tts] mutableCopy]));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAlertManeuver* testRequest = [[SDLAlertManeuver alloc] init];
        
        expect(testRequest.ttsChunks).to(beNil());
        expect(testRequest.softButtons).to(beNil());
    });
});

QuickSpecEnd