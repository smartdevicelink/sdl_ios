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
#import "SDLHapticRect.h"
#import "SDLRectangle.h"
#import "SDLSendHapticData.h"

QuickSpecBegin(SDLSendHapticDataSpec)

describe(@"Initialization Tests", ^ {
    __block SDLHapticRect *testStruct = nil;

    beforeEach(^{
        testStruct = [[SDLHapticRect alloc] initWithId:123 rect:[[SDLRectangle alloc] initWithX:23.1 y:45.6 width:69.0 height:69]];
    });

    context(@"Getter/Setter Tests", ^ {
        it(@"Should set and get correctly", ^ {
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] init];
            testRequest.hapticRectData = [@[testStruct] mutableCopy];

            expect(testRequest.hapticRectData).to(equal(@[testStruct]));
        });
    });

    context(@"Init tests", ^{
        it(@"Should get correctly when initialized with a dictionary", ^ {
            NSMutableDictionary* dict = [@{SDLNameRequest:
                                               @{SDLNameParameters:
                                                     @{SDLNameHapticRectData:@[testStruct]},
                                                 SDLNameOperationName:SDLNameSendHapticData}} mutableCopy];
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] initWithDictionary:dict];

            expect(testRequest.hapticRectData).to(equal(@[testStruct]));
        });

        it(@"Should initialize correctly with initWithType:", ^{
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] initWithHapticRectData:@[testStruct]];

            expect(testRequest.hapticRectData).to(equal(@[testStruct]));
        });

        it(@"Should return nil if not set", ^ {
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] init];

            expect(testRequest.hapticRectData).to(beNil());
        });
    });
});

QuickSpecEnd
