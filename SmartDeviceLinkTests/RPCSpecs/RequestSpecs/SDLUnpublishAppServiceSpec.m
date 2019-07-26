//
//  SDLUnpublishAppServiceSpec.m
//  SmartDeviceLinkTests
//
//  Created by Bretty White on 7/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLUnpublishAppService.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLUnpublishAppServiceSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLUnpublishAppService* testRequest = [[SDLUnpublishAppService alloc] init];
        
        testRequest.serviceID = @"idToUnpublish";
        
        expect(testRequest.serviceID).to(equal(@"idToUnpublish"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                   @{SDLRPCParameterNameParameters:
                                                         @{SDLRPCParameterNameServiceID:@"idToUnpublish"},
                                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameUnpublishAppService}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLUnpublishAppService* testRequest = [[SDLUnpublishAppService alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.serviceID).to(equal(@"idToUnpublish"));
    });
    
    it(@"should properly initialize with serviceID:", ^{
        SDLUnpublishAppService *testRequest = [[SDLUnpublishAppService alloc] initWithServiceID:@"idToUnpublish"];
        
        expect(testRequest.serviceID).to(equal(@"idToUnpublish"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLUnpublishAppService* testRequest = [[SDLUnpublishAppService alloc] init];
        
        expect(testRequest.serviceID).to(beNil());
    });
});

QuickSpecEnd
