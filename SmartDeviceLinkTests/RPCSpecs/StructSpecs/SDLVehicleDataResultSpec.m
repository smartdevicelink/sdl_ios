//
//  SDLVehicleDataResultSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLVehicleDataResult.h"
#import "SDLVehicleDataResultCode.h"
#import "SDLVehicleDataType.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLVehicleDataResultSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"should correctly initialize with init", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] init];
        
        testStruct.dataType = SDLVehicleDataTypeAirbagStatus;
        testStruct.customOEMDataType = @"CustomOEMData";
        testStruct.resultCode = SDLVehicleDataResultCodeDisallowed;
        
        expect(testStruct.dataType).to(equal(SDLVehicleDataTypeAirbagStatus));
        expect(testStruct.customOEMDataType).to(equal(@"CustomOEMData"));
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDisallowed));
    });

    it(@"should correctly initialize with initWithDataType", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] initWithDataType:SDLVehicleDataTypeAirbagStatus resultCode:SDLVehicleDataResultCodeDisallowed];

        expect(testStruct.dataType).to(equal(SDLVehicleDataTypeAirbagStatus));
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDisallowed));
    });

    it(@"should correctly initialize with initWithCustomOEMDataType", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] initWithCustomOEMDataType:@"CustomOEMData" resultCode:SDLVehicleDataResultCodeDisallowed];

        expect(testStruct.customOEMDataType).to(equal(@"CustomOEMData"));
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDisallowed));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary* dict = [@{SDLRPCParameterNameDataType:SDLVehicleDataTypeAirbagStatus,
                                       SDLRPCParameterNameResultCode:SDLVehicleDataResultCodeDisallowed,
                                       SDLRPCParameterNameOEMCustomDataType:@"CustomOEMData"
                                       } mutableCopy];
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] initWithDictionary:dict];
        
        expect(testStruct.dataType).to(equal(SDLVehicleDataTypeAirbagStatus));
        expect(testStruct.customOEMDataType).to(equal(@"CustomOEMData"));
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDisallowed));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] init];
        
        expect(testStruct.dataType).to(beNil());
        expect(testStruct.customOEMDataType).to(beNil());
        expect(testStruct.resultCode).to(beNil());
    });
});

QuickSpecEnd
