//
//  SDLSubscribeButtonSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSubscribeButton.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSubscribeButtonSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        testRequest.buttonName = [SDLButtonName PRESET_5];
        
        expect(testRequest.buttonName).to(equal([SDLButtonName PRESET_5]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_buttonName:[SDLButtonName PRESET_5]},
                                             NAMES_operation_name:NAMES_SubscribeButton}} mutableCopy];
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] initWithDictionary:dict];
        
        expect(testRequest.buttonName).to(equal([SDLButtonName PRESET_5]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        expect(testRequest.buttonName).to(beNil());
    });
});

QuickSpecEnd