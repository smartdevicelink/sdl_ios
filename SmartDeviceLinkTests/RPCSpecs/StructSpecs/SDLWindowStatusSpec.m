//
//  SDLWindowStatusSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLWindowStatus.h"
#import "SDLWindowState.h"
#import "SDLGrid.h"
#import "SDLRPCParameterNames.h"

const UInt8 approximatePosition = 13;
const UInt8 deviation = 42;

QuickSpecBegin(SDLWindowStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLWindowState *state = [[SDLWindowState alloc] initWithApproximatePosition:approximatePosition deviation:deviation];
        SDLGrid *location = [SDLGrid new];
        SDLWindowStatus *testStruct = [[SDLWindowStatus alloc] initWithLocation:location state:state];

        expect(testStruct.location).to(equal(location));
        expect(testStruct.state).to(equal(state));
    });

    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{@"location":location,
                                @"state":state
                                };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLWindowStatus *testStruct = [[SDLWindowStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.location).to(equal(location));
        expect(testStruct.state).to(equal(state));
    });

    it(@"Should return nil if not set", ^ {
        SDLWindowStatus *testStruct = [SDLWindowStatus new];

        expect(testStruct.location).to(beNil());
        expect(testStruct.state).to(beNil());
    });
});

QuickSpecEnd
