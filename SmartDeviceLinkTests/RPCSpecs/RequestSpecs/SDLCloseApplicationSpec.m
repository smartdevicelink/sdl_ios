//
//  SDLCloseApplicationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/10/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCloseApplication.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

QuickSpecBegin(SDLCloseApplicationSpec)

describe(@"Getter/Setter Tests", ^{
    it(@"Should initialize correctly", ^{
        SDLCloseApplication *testRequest = [[SDLCloseApplication alloc] init];
        expect(testRequest.name).to(equal(SDLRPCFunctionNameCloseApplication));
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{},
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameCloseApplication}};
        SDLCloseApplication *testRequest = [[SDLCloseApplication alloc] initWithDictionary:dict];

        expect(testRequest.name).to(equal(SDLRPCFunctionNameCloseApplication));
        expect(testRequest.parameters).to(beEmpty());
    });
});

QuickSpecEnd

