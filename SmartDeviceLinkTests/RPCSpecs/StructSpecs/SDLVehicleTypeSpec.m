//
//  SDLVehicleTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleType.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLVehicleTypeSpec)

describe(@"Getter/Setter Tests", ^ {
    NSString *make = @"make";
    NSString *model = @"model";
    NSString *modelYear = @"modelYear";
    NSString *trim = @"trim";

    it(@"Should set and get correctly", ^ {
        SDLVehicleType *testStruct = [[SDLVehicleType alloc] init];
        
        testStruct.make = make;
        testStruct.model = model;
        testStruct.modelYear = modelYear;
        testStruct.trim = trim;
        
        expect(testStruct.make).to(equal(make));
        expect(testStruct.model).to(equal(model));
        expect(testStruct.modelYear).to(equal(modelYear));
        expect(testStruct.trim).to(equal(trim));
    });
    
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{
            SDLRPCParameterNameMake: make,
            SDLRPCParameterNameModel: model,
            SDLRPCParameterNameModelYear: modelYear,
            SDLRPCParameterNameTrim: trim
        };
        SDLVehicleType *testStruct = [[SDLVehicleType alloc] initWithDictionary:dict];
        
        expect(testStruct.make).to(equal(make));
        expect(testStruct.model).to(equal(model));
        expect(testStruct.modelYear).to(equal(modelYear));
        expect(testStruct.trim).to(equal(trim));
    });
    
    it(@"should initialize correctly with init", ^ {
        SDLVehicleType *testStruct = [[SDLVehicleType alloc] init];
        
        expect(testStruct.make).to(beNil());
        expect(testStruct.model).to(beNil());
        expect(testStruct.modelYear).to(beNil());
        expect(testStruct.trim).to(beNil());
    });

    it(@"should initialize correctly with initWithMake:model:modelYear:trim:", ^{
        SDLVehicleType *testStruct = [[SDLVehicleType alloc] initWithMake:make model:model modelYear:modelYear trim:trim];

        expect(testStruct.make).to(equal(make));
        expect(testStruct.model).to(equal(model));
        expect(testStruct.modelYear).to(equal(modelYear));
        expect(testStruct.trim).to(equal(trim));
    });
});

QuickSpecEnd
