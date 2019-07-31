//
//  SDLUnpublishAppServiceResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Bretty White on 7/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLUnpublishAppServiceResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLUnpublishAppServiceResponseSpec)

describe(@"Getter/Setter Tests", ^{
    it(@"Should initialize correctly", ^{
        SDLUnpublishAppServiceResponse *testResponse = [[SDLUnpublishAppServiceResponse alloc] init];
        expect(testResponse.name).to(equal(SDLRPCFunctionNameUnpublishAppService));
    });
    
    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{},
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameUnpublishAppService}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLUnpublishAppServiceResponse *testResponse = [[SDLUnpublishAppServiceResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testResponse.name).to(equal(SDLRPCFunctionNameUnpublishAppService));
        expect(testResponse.parameters).to(beEmpty());
    });
});

QuickSpecEnd
