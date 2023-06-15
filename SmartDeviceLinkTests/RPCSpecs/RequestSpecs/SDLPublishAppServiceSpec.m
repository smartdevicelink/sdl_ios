//
//  SDLPublishAppServiceSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLAppServiceManifest.h"
#import "SDLPublishAppService.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLPublishAppServiceSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLAppServiceManifest *testAppServiceManifest = nil;

    beforeEach(^{
        testAppServiceManifest = [[SDLAppServiceManifest alloc] init];
    });

    it(@"Should set and get correctly", ^{
        SDLPublishAppService *testRequest = [[SDLPublishAppService alloc] init];
        testRequest.appServiceManifest = testAppServiceManifest;

        expect(testRequest.appServiceManifest).to(equal(testAppServiceManifest));
    });

    it(@"Should return nil if not set", ^{
        SDLPublishAppService *testRequest = [[SDLPublishAppService alloc] init];

        expect(testRequest.appServiceManifest).to(beNil());
    });

    describe(@"initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^{
            NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                           SDLRPCParameterNameParameters:@{
                                                   SDLRPCParameterNameAppServiceManifest:testAppServiceManifest
                                                   },
                                           SDLRPCParameterNameOperationName:SDLRPCFunctionNamePublishAppService}};
            SDLPublishAppService *testRequest = [[SDLPublishAppService alloc] initWithDictionary:dict];

            expect(testRequest.appServiceManifest).to(equal(testAppServiceManifest));
        });

        it(@"Should initialize correctly with initWithAppServiceManifest:", ^{
            SDLPublishAppService *testRequest = [[SDLPublishAppService alloc] initWithAppServiceManifest:testAppServiceManifest];

            expect(testRequest.appServiceManifest).to(equal(testAppServiceManifest));
        });
    });
});

QuickSpecEnd
