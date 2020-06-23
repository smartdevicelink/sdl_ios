//
//  SDLStabilityControlsStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLStabilityControlsStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLVehicleDataStatus.h"


QuickSpecBegin(SDLStabilityControlsStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly (On)", ^ {
        SDLStabilityControlsStatus* testStruct = [SDLStabilityControlsStatus new];
        testStruct.escSystem = SDLVehicleDataStatusOn;
        testStruct.trailerSwayControl = SDLVehicleDataStatusOn;
        expect(testStruct.escSystem).to(equal(SDLVehicleDataStatusOn));
        expect(testStruct.trailerSwayControl).to(equal(SDLVehicleDataStatusOn));
    });

    it(@"Should set and get correctly (Off)", ^ {
        SDLStabilityControlsStatus* testStruct = [SDLStabilityControlsStatus new];
        testStruct.escSystem = SDLVehicleDataStatusOff;
        testStruct.trailerSwayControl = SDLVehicleDataStatusOff;
        expect(testStruct.escSystem).to(equal(SDLVehicleDataStatusOff));
        expect(testStruct.trailerSwayControl).to(equal(SDLVehicleDataStatusOff));
    });
    
        it(@"Should get correctly when initialized with a dict (On)", ^ {
            NSDictionary* dict = @{@"escSystem":SDLVehicleDataStatusOn,
                                   @"trailerSwayControl":SDLVehicleDataStatusOn};

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

            expect(testStruct.escSystem).to(equal(SDLVehicleDataStatusOn));
            expect(testStruct.trailerSwayControl).to(equal(SDLVehicleDataStatusOn));
        });

    it(@"Should get correctly when initialized with a dict (Off)", ^ {
        NSDictionary* dict = @{@"escSystem":SDLVehicleDataStatusOff,
                               @"trailerSwayControl":SDLVehicleDataStatusOff};

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLStabilityControlsStatus* testStruct = [[SDLStabilityControlsStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.escSystem).to(equal(SDLVehicleDataStatusOff));
        expect(testStruct.trailerSwayControl).to(equal(SDLVehicleDataStatusOff));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLStabilityControlsStatus* testStruct = [SDLStabilityControlsStatus new];
        expect(testStruct.escSystem).to(beNil());
        expect(testStruct.trailerSwayControl).to(beNil());
    });
});

QuickSpecEnd
