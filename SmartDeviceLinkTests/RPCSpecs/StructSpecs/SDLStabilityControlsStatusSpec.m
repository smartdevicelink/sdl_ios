//
//  SDLStabilityControlsStatusSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLRPCParameterNames.h"
#import "SDLStabilityControlsStatus.h"
#import "SDLVehicleDataStatus.h"

QuickSpecBegin(SDLStabilityControlsStatusSpec)

describe(@"getter/setter tests", ^ {
    it(@"should set and get correctly", ^ {
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] init];
        testStruct.escSystem = SDLVehicleDataStatusOn;
        testStruct.trailerSwayControl = SDLVehicleDataStatusOn;
        expect(testStruct.escSystem).to(equal(SDLVehicleDataStatusOn));
        expect(testStruct.trailerSwayControl).to(equal(SDLVehicleDataStatusOn));
    });

    it(@"should get correctly when initialized with a dict", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameEscSystem:SDLVehicleDataStatusOn, SDLRPCParameterNameTrailerSwayControl:SDLVehicleDataStatusOn};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.escSystem).to(equal(SDLVehicleDataStatusOn));
        expect(testStruct.trailerSwayControl).to(equal(SDLVehicleDataStatusOn));
    });

    it(@"should return nil if not set", ^ {
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] init];
        expect(testStruct.escSystem).to(beNil());
        expect(testStruct.trailerSwayControl).to(beNil());
    });

    context(@"initWithEscSystem:trailerSwayControl:", ^{
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] initWithEscSystem:SDLVehicleDataStatusOff trailerSwayControl:SDLVehicleDataStatusOff];
        it(@"expect all properties to be set properly", ^ {
            expect(testStruct.escSystem).to(equal(SDLVehicleDataStatusOff));
            expect(testStruct.trailerSwayControl).to(equal(SDLVehicleDataStatusOff));
        });
    });
});

QuickSpecEnd
