//
//  SDLSeekStreamingIndicatorSpec.m
//  SmartDeviceLinkTests
//
//  Created by Frank Elias on 12/8/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLSeekIndicatorType.h"
#import "SDLSeekStreamingIndicator.h"

QuickSpecBegin(SDLSeekStreamingIndicatorSpec)

describe(@"Getter/Setter Tests", ^ {
    __block NSUInteger testSeekTimeInt = 10;
    __block NSNumber<SDLUInt> *testSeekTime = nil;
    __block SDLSeekIndicatorType testSeekIndicatorType = nil;

    beforeEach(^{
        testSeekTime = [[NSNumber alloc] initWithUnsignedInteger:testSeekTimeInt];
        testSeekIndicatorType = SDLSeekIndicatorTypeTime;
    });

    it(@"Should set and get correctly", ^ {
        SDLSeekStreamingIndicator *testStruct = [[SDLSeekStreamingIndicator alloc] init];

        testStruct.seekTime = testSeekTime;
        testStruct.type = testSeekIndicatorType;

        expect(testStruct.seekTime).to(equal([[NSNumber alloc] initWithUnsignedInteger:testSeekTimeInt]));
        expect(testStruct.type).to(equal(SDLSeekIndicatorTypeTime));
    });

    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{
                               SDLRPCParameterNameSeekTime: testSeekTime,
                               SDLRPCParameterNameType: testSeekIndicatorType
                               };
        SDLSeekStreamingIndicator* testStruct = [[SDLSeekStreamingIndicator alloc] initWithDictionary:dict];

        expect(testStruct.seekTime).to(equal([[NSNumber alloc] initWithUnsignedInteger:testSeekTimeInt]));
        expect(testStruct.type).to(equal(SDLSeekIndicatorTypeTime));
    });

    it(@"Should set with initWithType: correctly", ^ {
        SDLSeekStreamingIndicator *testStruct = [[SDLSeekStreamingIndicator alloc] initWithType:testSeekIndicatorType];

        expect(testStruct.seekTime).to(beNil());
        expect(testStruct.type).to(equal(SDLSeekIndicatorTypeTime));
    });

    it(@"Should set with initWithType:seekTime: correctly", ^ {
        SDLSeekStreamingIndicator *testStruct = [[SDLSeekStreamingIndicator alloc] initWithType:testSeekIndicatorType seekTime:testSeekTime];

        expect(testStruct.seekTime).to(equal([[NSNumber alloc] initWithUnsignedInteger:testSeekTimeInt]));
        expect(testStruct.type).to(equal(SDLSeekIndicatorTypeTime));
    });

    it(@"Should set with initWithType:seekTime: correctly", ^ {
        SDLSeekStreamingIndicator *testStruct = [SDLSeekStreamingIndicator seekIndicatorWithSeekTime:testSeekTimeInt];

        expect(testStruct.seekTime).to(equal([[NSNumber alloc] initWithUnsignedInteger:testSeekTimeInt]));
        expect(testStruct.type).to(equal(SDLSeekIndicatorTypeTime));
    });

    it(@"Should return nil if not set", ^ {
        SDLSeekStreamingIndicator *testStruct = [[SDLSeekStreamingIndicator alloc] init];

        expect(testStruct.seekTime).to(beNil());
        expect(testStruct.type).to(beNil());
    });
});

QuickSpecEnd
