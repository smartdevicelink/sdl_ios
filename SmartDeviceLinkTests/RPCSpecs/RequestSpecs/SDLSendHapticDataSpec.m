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
#import "SDLHapticRect.h"

QuickSpecBegin(SDLSendHapticDataSpec)

describe(@"Initialization Tests", ^ {
    __block SDLHapticRect *testStruct = nil;

    beforeEach(^{
        NSMutableDictionary *dict = [@{NAMES_id:@2,
                                       NAMES_hapticRectData: @{
                                               NAMES_x:@20,
                                               NAMES_y:@200,
                                               NAMES_width:@2000,
                                               NAMES_height:@3000
                                               }} mutableCopy];
         testStruct = [[SDLHapticRect alloc] initWithDictionary:dict];
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
            NSMutableDictionary* dict = [@{NAMES_request:
                                               @{NAMES_parameters:
                                                     @{NAMES_hapticRectData:@[testStruct]},
                                                 NAMES_operation_name:NAMES_SendHapticData}} mutableCopy];
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] initWithDictionary:dict];

            expect(testRequest.hapticRectData).to(equal(@[testStruct]));
        });

        it(@"Should initialize correctly with initWithType:", ^{
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] initWithHapticRectData:[NSMutableArray arrayWithArray:@[testStruct]]];

            expect(testRequest.hapticRectData).to(equal(@[testStruct]));
        });

        it(@"Should return nil if not set", ^ {
            SDLSendHapticData *testRequest = [[SDLSendHapticData alloc] init];
            
            expect(testRequest.hapticRectData).to(beNil());
        });
    });
});



QuickSpecEnd
