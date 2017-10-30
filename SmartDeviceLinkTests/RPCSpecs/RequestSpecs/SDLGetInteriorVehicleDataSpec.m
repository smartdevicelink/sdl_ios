//
//  SDLGetInteriorVehicleDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetInteriorVehicleData.h"
#import "SDLModuleType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetInteriorVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] init];
        testRequest.moduleType = SDLModuleTypeRadio;
        testRequest.subscribe = @YES;

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
    });

    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameModuleType : SDLModuleTypeRadio,
                                                                   SDLNameSubscribe : @YES},
                                                             SDLNameOperationName:SDLNameGetInteriorVehicleData}} mutableCopy];
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initWithDictionary:dict];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
    });

    it(@"Should get correctly when initialized with module type", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initWithModuleType:SDLModuleTypeRadio];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
    });

    it(@"Should get correctly when initialized with module type and subscribe", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initAndSubscribeToModuleType:SDLModuleTypeRadio];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@YES));
    });

    it(@"Should get correctly when initialized with module type and unsubscribe", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] initAndUnsubscribeToModuleType:SDLModuleTypeRadio];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testRequest.subscribe).to(equal(@NO));
    });


    it(@"Should return nil if not set", ^ {
        SDLGetInteriorVehicleData* testRequest = [[SDLGetInteriorVehicleData alloc] init];

        expect(testRequest.moduleType).to(beNil());
        expect(testRequest.subscribe).to(beNil());
    });
});

QuickSpecEnd
