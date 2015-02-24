//
//  SDLMenuParamsSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMenuParams.h"
#import "SDLNames.h"

QuickSpecBegin(SDLMenuParamsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] init];
        
        testStruct.parentID = @504320489;
        testStruct.position = @256;
        testStruct.menuName = @"Menu";
        
        expect(testStruct.parentID).to(equal(@504320489));
        expect(testStruct.position).to(equal(@256));
        expect(testStruct.menuName).to(equal(@"Menu"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_parentID:@504320489,
                                       NAMES_position:@256,
                                       NAMES_menuName:@"Menu"} mutableCopy];
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] initWithDictionary:dict];
        
        expect(testStruct.parentID).to(equal(@504320489));
        expect(testStruct.position).to(equal(@256));
        expect(testStruct.menuName).to(equal(@"Menu"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLMenuParams* testStruct = [[SDLMenuParams alloc] init];
        
        expect(testStruct.parentID).to(beNil());
        expect(testStruct.position).to(beNil());
        expect(testStruct.menuName).to(beNil());
    });
});

QuickSpecEnd