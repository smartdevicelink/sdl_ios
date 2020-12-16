//
//  SDLReleaseInteriorVehicleDataModuleSpec.m
//  SmartDeviceLinkTests
//
//  Created by standa1 on 7/29/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLReleaseInteriorVehicleDataModule.h"
#import "SDLModuleType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLReleaseInteriorVehicleDataModuleSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLReleaseInteriorVehicleDataModule *testRequest = [[SDLReleaseInteriorVehicleDataModule alloc] init];
        testRequest.moduleType = SDLModuleTypeRadio;
        testRequest.moduleId = @"123";
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleId).to(equal(@"123"));
    });
    
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameModuleType: SDLModuleTypeRadio,
                                                                   SDLRPCParameterNameModuleId: @"123"},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetInteriorVehicleData}} mutableCopy];
        SDLReleaseInteriorVehicleDataModule *testRequest = [[SDLReleaseInteriorVehicleDataModule alloc] initWithDictionary:dict];
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleId).to(equal(@"123"));
    });
    
    it(@"Should get correctly when initialized with module type and module ids", ^ {
        SDLReleaseInteriorVehicleDataModule *testRequest = [[SDLReleaseInteriorVehicleDataModule alloc] initWithModuleType:SDLModuleTypeRadio moduleId:@"123"];
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleId).to(equal(@"123"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLReleaseInteriorVehicleDataModule *testRequest = [[SDLReleaseInteriorVehicleDataModule alloc] init];

        expect(testRequest.moduleType).to(beNil());
        expect(testRequest.moduleId).to(beNil());
    });
});

QuickSpecEnd
