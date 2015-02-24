//
//  SDLVehicleDataResultSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataResult.h"
#import "SDLNames.h"

QuickSpecBegin(SDLVehicleDataResultSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] init];
        
        testStruct.dataType = [SDLVehicleDataType VEHICLEDATA_AIRBAGSTATUS];
        testStruct.resultCode = [SDLVehicleDataResultCode DISALLOWED];
        
        expect(testStruct.dataType).to(equal([SDLVehicleDataType VEHICLEDATA_AIRBAGSTATUS]));
        expect(testStruct.resultCode).to(equal([SDLVehicleDataResultCode DISALLOWED]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_dataType:[SDLVehicleDataType VEHICLEDATA_AIRBAGSTATUS],
                                       NAMES_resultCode:[SDLVehicleDataResultCode DISALLOWED]} mutableCopy];
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] initWithDictionary:dict];
        
        expect(testStruct.dataType).to(equal([SDLVehicleDataType VEHICLEDATA_AIRBAGSTATUS]));
        expect(testStruct.resultCode).to(equal([SDLVehicleDataResultCode DISALLOWED]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLVehicleDataResult* testStruct = [[SDLVehicleDataResult alloc] init];
        
        expect(testStruct.dataType).to(beNil());
        expect(testStruct.resultCode).to(beNil());
    });
});

QuickSpecEnd