//
//  SDLHapticRectSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLHapticRect.h"
#import "SDLRectangle.h"

QuickSpecBegin(SDLHapticRectSpec)

describe(@"Getter/Setter Tests", ^{
    it(@"Should set and get correctly", ^{
        SDLRectangle *testRect = [[SDLRectangle alloc] initWithX:@1 y:@2 width:@3 height:@4];
        SDLHapticRect *testStruct = [[SDLHapticRect alloc] init];

        testStruct.id = @1;
        testStruct.rect = testRect;

        expect(testStruct.id).to(equal(@1));
        expect(testStruct.rect).to(equal(testRect));
    });

    it(@"Should get correctly when initialized", ^{
        NSMutableDictionary *dict = [@{NAMES_id:@2,
                                       NAMES_rect: @{
                                               NAMES_x:@20,
                                               NAMES_y:@200,
                                               NAMES_width:@2000,
                                               NAMES_height:@3000
                                               }} mutableCopy];
        SDLHapticRect * testStruct = [[SDLHapticRect alloc] initWithDictionary:dict];

        expect(testStruct.id).to(equal(@2));
        expect(testStruct.rect.x).to(equal(@20));
        expect(testStruct.rect.y).to(equal(@200));
        expect(testStruct.rect.width).to(equal(@2000));
        expect(testStruct.rect.height).to(equal(@3000));
    });

    it(@"Should return nil if not set", ^{
        SDLHapticRect *testStruct = [[SDLHapticRect alloc] init];

        expect(testStruct.id).to(beNil());
        expect(testStruct.rect).to(beNil());
    });
});

QuickSpecEnd
