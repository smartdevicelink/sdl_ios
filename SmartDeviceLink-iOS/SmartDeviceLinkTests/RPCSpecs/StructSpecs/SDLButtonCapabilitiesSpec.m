//
//  SDLButtonCapabilitiesSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLButtonCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] init];
        
        testStruct.name = [SDLButtonName TUNEUP];
        testStruct.shortPressAvailable = [NSNumber numberWithBool:YES];
        testStruct.longPressAvailable = [NSNumber numberWithBool:YES];
        testStruct.upDownAvailable = [NSNumber numberWithBool:NO];
        
        expect(testStruct.name).to(equal([SDLButtonName TUNEUP]));
        expect(testStruct.shortPressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.longPressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.upDownAvailable).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_name:[SDLButtonName CUSTOM_BUTTON],
                                       NAMES_shortPressAvailable:[NSNumber numberWithBool:YES],
                                       NAMES_longPressAvailable:[NSNumber numberWithBool:YES],
                                       NAMES_upDownAvailable:[NSNumber numberWithBool:NO]} mutableCopy];
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.name).to(equal([SDLButtonName CUSTOM_BUTTON]));
        expect(testStruct.shortPressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.longPressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.upDownAvailable).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] init];
        
        expect(testStruct.name).to(beNil());
        expect(testStruct.shortPressAvailable).to(beNil());
        expect(testStruct.longPressAvailable).to(beNil());
        expect(testStruct.upDownAvailable).to(beNil());
    });
});

QuickSpecEnd