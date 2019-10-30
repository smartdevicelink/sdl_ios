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
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameModuleType : SDLModuleTypeRadio,
                                                                   SDLRPCParameterNameModuleId: @"123",
                                                                   SDLRPCParameterNameSubscribe : @YES},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetInteriorVehicleData}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

    it(@"Should get correctly when initialized with module type", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initWithModuleType:SDLModuleTypeRadio];
#pragma clang diagnostic pop

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleId).to(beNil());
    });

    it(@"Should get correctly when initialized with module type", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initWithModuleType:SDLModuleTypeRadio moduleId:@"123"];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

    it(@"Should get correctly when initialized with module type and subscribe", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initAndSubscribeToModuleType:SDLModuleTypeRadio];
#pragma clang diagnostic pop

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
        expect(testRequest.moduleId).to(beNil());
    });

    it(@"Should get correctly when initialized with module type and subscribe", ^ {
    SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initAndSubscribeToModuleType:SDLModuleTypeRadio moduleId:@"123"];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
        expect(testRequest.moduleId).to(equal(@"123"));
    });

    it(@"Should get correctly when initialized with module type and unsubscribe", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initAndUnsubscribeToModuleType:SDLModuleTypeRadio];
#pragma clang diagnostic pop

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@NO));
        expect(testRequest.moduleId).to(beNil());
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
