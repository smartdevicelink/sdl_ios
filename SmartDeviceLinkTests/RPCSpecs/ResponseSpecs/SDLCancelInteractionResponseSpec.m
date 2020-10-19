//
//  SDLCancelInteractionResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCancelInteractionResponse.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLCancelInteractionResponseSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLCancelInteractionResponse *testResponse = nil;

    it(@"Should initialize correctly", ^{
         testResponse = [[SDLCancelInteractionResponse alloc] init];
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{},
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameCancelInteraction}};
        testResponse = [[SDLCancelInteractionResponse alloc] initWithDictionary:dict];
    });

    afterEach(^{
        expect(testResponse.name).to(match(SDLRPCFunctionNameCancelInteraction));
        expect(testResponse.parameters).to(beEmpty());
    });
});

QuickSpecEnd
