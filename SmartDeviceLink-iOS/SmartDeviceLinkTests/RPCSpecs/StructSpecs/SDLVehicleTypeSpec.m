//
//  SDLVehicleTypeSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLVehicleTypeSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLVehicleType* testStruct = [[SDLVehicleType alloc] init];
        
        testStruct.make = @"Make";
        testStruct.model = @"Model";
        testStruct.modelYear = @"3.141*10^36";
        testStruct.trim = @"AE";
        
        expect(testStruct.make).to(equal(@"Make"));
        expect(testStruct.model).to(equal(@"Model"));
        expect(testStruct.modelYear).to(equal(@"3.141*10^36"));
        expect(testStruct.trim).to(equal(@"AE"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_make:@"Make",
                                       NAMES_model:@"Model",
                                       NAMES_modelYear:@"3.141*10^36",
                                       NAMES_trim:@"AE"} mutableCopy];
        SDLVehicleType* testStruct = [[SDLVehicleType alloc] initWithDictionary:dict];
        
        expect(testStruct.make).to(equal(@"Make"));
        expect(testStruct.model).to(equal(@"Model"));
        expect(testStruct.modelYear).to(equal(@"3.141*10^36"));
        expect(testStruct.trim).to(equal(@"AE"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLVehicleType* testStruct = [[SDLVehicleType alloc] init];
        
        expect(testStruct.make).to(beNil());
        expect(testStruct.model).to(beNil());
        expect(testStruct.modelYear).to(beNil());
        expect(testStruct.trim).to(beNil());
    });
});

QuickSpecEnd