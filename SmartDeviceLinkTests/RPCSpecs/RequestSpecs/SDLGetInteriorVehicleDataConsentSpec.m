//
//  SDLGetInteriorVehicleDataConsentSpec.m
//  SmartDeviceLinkTests
//
//  Created by standa1 on 7/29/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetInteriorVehicleDataConsent.h"
#import "SDLModuleType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetInteriorVehicleDataConsentSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetInteriorVehicleDataConsent *testRequest = [[SDLGetInteriorVehicleDataConsent alloc] init];
        testRequest.moduleType = SDLModuleTypeRadio;
        testRequest.moduleIds = @[@"123", @"456"];
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleIds).to(equal(@[@"123", @"456"]));
    });
    
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameModuleType : SDLModuleTypeRadio,
                                                                   SDLRPCParameterNameModuleIds: @[@"123", @"456"]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetInteriorVehicleData}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetInteriorVehicleDataConsent *testRequest = [[SDLGetInteriorVehicleDataConsent alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleIds).to(equal(@[@"123", @"456"]));
    });
    
    it(@"Should get correctly when initialized with module type and module ids", ^ {
        SDLGetInteriorVehicleDataConsent *testRequest = [[SDLGetInteriorVehicleDataConsent alloc] initWithModuleType:SDLModuleTypeRadio moduleIds:@[@"123", @"456"]];
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleIds).to(equal(@[@"123", @"456"]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetInteriorVehicleDataConsent *testRequest = [[SDLGetInteriorVehicleDataConsent alloc] init];

        expect(testRequest.moduleType).to(beNil());
        expect(testRequest.moduleIds).to(beNil());
    });
});

QuickSpecEnd
