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

describe(@"getter/setter tests", ^{
    // set up test constants
    SDLVehicleDataStatus escSystem = SDLVehicleDataStatusOn;
    SDLVehicleDataStatus trailerSwayControl = SDLVehicleDataStatusOn;

    context(@"init and assign", ^{
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] init];
        testStruct.escSystem = escSystem;
        testStruct.trailerSwayControl = trailerSwayControl;

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.escSystem).to(equal(escSystem));
            expect(testStruct.trailerSwayControl).to(equal(trailerSwayControl));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary* dict = @{
                               SDLRPCParameterNameEscSystem:escSystem,
                               SDLRPCParameterNameTrailerSwayControl:trailerSwayControl,
                              };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.escSystem).to(equal(escSystem));
            expect(testStruct.trailerSwayControl).to(equal(trailerSwayControl));
        });
    });

    context(@"init", ^{
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.escSystem).to(beNil());
            expect(testStruct.trailerSwayControl).to(beNil());
        });
    });

    context(@"initWithEscSystem:trailerSwayControl:", ^{
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] initWithEscSystem:escSystem trailerSwayControl:trailerSwayControl];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.escSystem).to(equal(escSystem));
            expect(testStruct.trailerSwayControl).to(equal(trailerSwayControl));
        });
    });
});

QuickSpecEnd
