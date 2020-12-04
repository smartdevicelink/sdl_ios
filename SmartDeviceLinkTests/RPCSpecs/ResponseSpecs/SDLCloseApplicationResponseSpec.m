//
//  SDLCloseApplicationResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/10/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCloseApplicationResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLCloseApplicationResponseSpec)

describe(@"Getter/Setter Tests", ^{
    it(@"Should initialize correctly", ^{
        SDLCloseApplicationResponse *testResponse = [[SDLCloseApplicationResponse alloc] init];
        expect(testResponse.name).to(equal(SDLRPCFunctionNameCloseApplication));
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{},
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameCloseApplication}};
        SDLCloseApplicationResponse *testResponse = [[SDLCloseApplicationResponse alloc] initWithDictionary:dict];

        expect(testResponse.name).to(equal(SDLRPCFunctionNameCloseApplication));
        expect(testResponse.parameters).to(beEmpty());
    });
});

QuickSpecEnd
