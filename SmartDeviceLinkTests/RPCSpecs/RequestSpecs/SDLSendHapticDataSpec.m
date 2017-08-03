//
//  SDLSendHapticDataSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
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
        NSMutableDictionary *dict = [@{NAMES_id:@2,
                                       NAMES_x:@20,
                                       NAMES_y:@200,
                                       NAMES_width:@2000,
                                       NAMES_height:@3000} mutableCopy];
         testStruct = [[SDLSpatialStruct alloc] initWithDictionary:dict];
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
            NSMutableDictionary* dict = [@{NAMES_request:
                                               @{NAMES_parameters:
                                                     @{NAMES_hapticSpatialData:@[testStruct]},
                                                 NAMES_operation_name:NAMES_SendHapticData}} mutableCopy];
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
