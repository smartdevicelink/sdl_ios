//
//  SDLVehicleDataResultSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataResult.h"
#import "SDLVehicleDataResultCode.h"
#import "SDLVehicleDataType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLVehicleDataResultSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] init];
        
        testStruct.dataType = SDLVehicleDataTypeAirbagStatus;
        testStruct.resultCode = SDLVehicleDataResultCodeDisallowed;
        
        expect(testStruct.dataType).to(equal(SDLVehicleDataTypeAirbagStatus));
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDisallowed));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameDataType:SDLVehicleDataTypeAirbagStatus,
                                       SDLNameResultCode:SDLVehicleDataResultCodeDisallowed} mutableCopy];
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] initWithDictionary:dict];
        
        expect(testStruct.dataType).to(equal(SDLVehicleDataTypeAirbagStatus));
        expect(testStruct.resultCode).to(equal(SDLVehicleDataResultCodeDisallowed));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] init];
        
        expect(testStruct.dataType).to(beNil());
        expect(testStruct.resultCode).to(beNil());
    });
});

QuickSpecEnd
