//
//  SDLVrHelpItemSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVrHelpItem.h"
#import "SDLNames.h"

QuickSpecBegin(SDLVrHelpItemSpec)

SDLImage* image = [[SDLImage alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLVrHelpItem* testStruct = [[SDLVrHelpItem alloc] init];
        
        testStruct.text = @"DON'T PANIC";
        testStruct.image = image;
        testStruct.position = @42;
        
        expect(testStruct.text).to(equal(@"DON'T PANIC"));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.position).to(equal(@42));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_text:@"DON'T PANIC",
                                       NAMES_image:image,
                                       NAMES_position:@42} mutableCopy];
        SDLVrHelpItem* testStruct = [[SDLVrHelpItem alloc] initWithDictionary:dict];
        
        expect(testStruct.text).to(equal(@"DON'T PANIC"));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.position).to(equal(@42));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLVrHelpItem* testStruct = [[SDLVrHelpItem alloc] init];
        
        expect(testStruct.text).to(beNil());
        expect(testStruct.image).to(beNil());
        expect(testStruct.position).to(beNil());
    });
});

QuickSpecEnd