//
//  SDLSpatialStructSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSpatialStruct.h"

QuickSpecBegin(SDLSpatialStructSpec)

describe(@"Getter/Setter Tests", ^{
    it(@"Should set and get correctly", ^{
        SDLSpatialStruct *testStruct = [[SDLSpatialStruct alloc] init];

        testStruct.id = @1;
        testStruct.x = @10;
        testStruct.y = @100;
        testStruct.width = @1000;
        testStruct.height = @2000;

        expect(testStruct.id).to(equal(@1));
        expect(testStruct.x).to(equal(@10));
        expect(testStruct.y).to(equal(@100));
        expect(testStruct.width).to(equal(@1000));
        expect(testStruct.height).to(equal(@2000));
    });

    it(@"Should get correctly when initialized with parameters", ^{
        SDLSpatialStruct *testStruct = [[SDLSpatialStruct alloc] initWithId:5 x:@50.0 y:@60.0 width:@500.0 height:@600.0];

        expect(testStruct.id).to(equal(@5));
        expect(testStruct.x).to(equal(@50.0));
        expect(testStruct.y).to(equal(@60.0));
        expect(testStruct.width).to(equal(@500.0));
        expect(testStruct.height).to(equal(@600.0));
    });

    it(@"Should get correctly when initialized with a dict", ^{
        NSMutableDictionary *dict = [@{SDLNameId:@2,
                                       SDLNameX:@20,
                                       SDLNameY:@200,
                                       SDLNameWidth:@2000,
                                       SDLNameHeight:@3000} mutableCopy];
        SDLSpatialStruct *testStruct = [[SDLSpatialStruct alloc] initWithDictionary:dict];

        expect(testStruct.id).to(equal(@2));
        expect(testStruct.x).to(equal(@20));
        expect(testStruct.y).to(equal(@200));
        expect(testStruct.width).to(equal(@2000));
        expect(testStruct.height).to(equal(@3000));
    });

    it(@"Should return nil if not set", ^{
        SDLSpatialStruct *testStruct = [[SDLSpatialStruct alloc] init];

        expect(testStruct.id).to(beNil());
        expect(testStruct.x).to(beNil());
        expect(testStruct.y).to(beNil());
        expect(testStruct.width).to(beNil());
        expect(testStruct.height).to(beNil());
    });
});

QuickSpecEnd
