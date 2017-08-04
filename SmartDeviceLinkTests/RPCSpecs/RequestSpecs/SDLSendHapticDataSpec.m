//
//  SDLSendHapticDataSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/4/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSendHapticData.h"
#import "SDLSpatialStruct.h"

QuickSpecBegin(SDLSendHapticDataSpec)

describe(@"Initialization Tests", ^ {
    __block SDLSpatialStruct *testStruct = nil;

    beforeEach(^{
        testStruct = [[SDLSpatialStruct alloc] initWithId:1 x:@20 y:@30 width:@100 height:@200];
    });

    context(@"Getter/Setter Tests", ^ {
        it(@"Should set and get correctly", ^ {
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] init];
            testRequest.hapticSpatialData = [@[testStruct] mutableCopy];

            expect(testRequest.hapticSpatialData).to(equal(@[testStruct]));
        });
    });

    context(@"Init tests", ^{
        it(@"Should get correctly when initialized with a dictionary", ^ {
            NSMutableDictionary* dict = [@{SDLNameRequest:
                                               @{SDLNameParameters:
                                                     @{SDLNameHapticSpatialData:@[testStruct]},
                                                 SDLNameOperationName:SDLNameSendHapticData}} mutableCopy];
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] initWithDictionary:dict];

            expect(testRequest.hapticSpatialData).to(equal(@[testStruct]));
        });

        it(@"Should initialize correctly with initWithType:", ^{
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] initWithHapticSpatialData:[NSMutableArray arrayWithArray:@[testStruct]]];

            expect(testRequest.hapticSpatialData).to(equal(@[testStruct]));
        });

        it(@"Should return nil if not set", ^ {
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] init];

            expect(testRequest.hapticSpatialData).to(beNil());
        });
    });
});

QuickSpecEnd
