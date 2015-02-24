//
//  SDLSetDisplayLayoutResponseSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSetDisplayLayoutResponse.h"
#import "SDLButtonCapabilities.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSetDisplayLayoutResponseSpec)

SDLDisplayCapabilities* info = [[SDLDisplayCapabilities alloc] init];
SDLButtonCapabilities* button = [[SDLButtonCapabilities alloc] init];
SDLSoftButtonCapabilities* softButton = [[SDLSoftButtonCapabilities alloc] init];
SDLPresetBankCapabilities* presetBank = [[SDLPresetBankCapabilities alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetDisplayLayoutResponse* testResponse = [[SDLSetDisplayLayoutResponse alloc] init];
        
        testResponse.displayCapabilities = info;
        testResponse.buttonCapabilities = [@[button] mutableCopy];
        testResponse.softButtonCapabilities = [@[softButton] mutableCopy];
        testResponse.presetBankCapabilities = presetBank;
        
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal([@[button] mutableCopy]));
        expect(testResponse.softButtonCapabilities).to(equal([@[softButton] mutableCopy]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_displayCapabilities:info,
                                                   NAMES_buttonCapabilities:[@[button] mutableCopy],
                                                   NAMES_softButtonCapabilities:[@[softButton] mutableCopy],
                                                   NAMES_presetBankCapabilities:presetBank},
                                             NAMES_operation_name:NAMES_SetDisplayLayout}} mutableCopy];
        SDLSetDisplayLayoutResponse* testResponse = [[SDLSetDisplayLayoutResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal([@[button] mutableCopy]));
        expect(testResponse.softButtonCapabilities).to(equal([@[softButton] mutableCopy]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetDisplayLayoutResponse* testResponse = [[SDLSetDisplayLayoutResponse alloc] init];
        
        expect(testResponse.displayCapabilities).to(beNil());
        expect(testResponse.buttonCapabilities).to(beNil());
        expect(testResponse.softButtonCapabilities).to(beNil());
        expect(testResponse.presetBankCapabilities).to(beNil());
    });
});

QuickSpecEnd