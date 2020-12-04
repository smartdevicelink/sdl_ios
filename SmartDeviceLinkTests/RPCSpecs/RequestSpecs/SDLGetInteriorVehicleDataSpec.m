//
//  SDLGetInteriorVehicleDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetInteriorVehicleData.h"
#import "SDLModuleType.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetInteriorVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] init];
        testRequest.moduleType = SDLModuleTypeRadio;
        testRequest.subscribe = @YES;
        testRequest.moduleId = @"123";

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameModuleType : SDLModuleTypeRadio,
                                           SDLRPCParameterNameModuleId: @"123",
                                           SDLRPCParameterNameSubscribe : @YES},
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetInteriorVehicleData}};
        SDLGetInteriorVehicleData *testRequest = [[SDLGetInteriorVehicleData alloc] initWithDictionary:dict];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

    it(@"Should get correctly when initialized with module type", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initWithModuleType:SDLModuleTypeRadio moduleId:@"123"];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

    it(@"Should get correctly when initialized with module type and subscribe", ^ {
    SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initAndSubscribeToModuleType:SDLModuleTypeRadio moduleId:@"123"];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

   it(@"Should get correctly when initialized with module type and unsubscribe", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initAndUnsubscribeToModuleType:SDLModuleTypeRadio moduleId:@"123"];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@NO));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

    it(@"Should return nil if not set", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] init];

        expect(testRequest.moduleType).to(beNil());
        expect(testRequest.subscribe).to(beNil());
        expect(testRequest.moduleId).to(beNil());
    });
});

QuickSpecEnd
