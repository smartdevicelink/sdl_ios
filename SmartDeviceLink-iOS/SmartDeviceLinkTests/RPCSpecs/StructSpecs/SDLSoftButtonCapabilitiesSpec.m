//
//  SDLSoftButtonCapabilitiesSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSoftButtonCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSoftButtonCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSoftButtonCapabilities* testStruct = [[SDLSoftButtonCapabilities alloc] init];
        
        testStruct.shortPressAvailable = [NSNumber numberWithBool:NO];
        testStruct.longPressAvailable = [NSNumber numberWithBool:YES];
        testStruct.upDownAvailable = [NSNumber numberWithBool:NO];
        testStruct.imageSupported = [NSNumber numberWithBool:NO];
        
        expect(testStruct.shortPressAvailable).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.longPressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.upDownAvailable).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.imageSupported).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_shortPressAvailable:[NSNumber numberWithBool:NO],
                                       NAMES_longPressAvailable:[NSNumber numberWithBool:YES],
                                       NAMES_upDownAvailable:[NSNumber numberWithBool:NO],
                                       NAMES_imageSupported:[NSNumber numberWithBool:NO]} mutableCopy];
        SDLSoftButtonCapabilities* testStruct = [[SDLSoftButtonCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.shortPressAvailable).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.longPressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.upDownAvailable).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.imageSupported).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSoftButtonCapabilities* testStruct = [[SDLSoftButtonCapabilities alloc] init];
        
        expect(testStruct.shortPressAvailable).to(beNil());
        expect(testStruct.longPressAvailable).to(beNil());
        expect(testStruct.upDownAvailable).to(beNil());
        expect(testStruct.imageSupported).to(beNil());
    });
});

QuickSpecEnd