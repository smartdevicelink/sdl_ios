//
//  SDLClimateControlDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLClimateData.h"
#import "SDLTemperature.h"
#import "SDLDefrostZone.h"
#import "SDLVentilationMode.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLClimateDataSpec)

describe(@"Getter/Setter Tests", ^{
    SDLTemperature *externalTemperature = [[SDLTemperature alloc] init];
    SDLTemperature *cabinTemperature = [[SDLTemperature alloc] init];
    NSNumber<SDLFloat> *atmosphericPressure = @(123.45);

    context(@"allocate new struct", ^{
        SDLClimateData* testStruct = [[SDLClimateData alloc] init];

        it(@"expect all values to be nil", ^{
            expect(testStruct.externalTemperature).to(beNil());
            expect(testStruct.cabinTemperature).to(beNil());
            expect(testStruct.atmosphericPressure).to(beNil());
        });
    });

    context(@"allocate and init new struct", ^{
        SDLClimateData* testStruct = [[SDLClimateData alloc] initWithExternalTemperature:externalTemperature cabinTemperature:cabinTemperature atmosphericPressure:atmosphericPressure];

        it(@"expect all properties to be equal to their initial values", ^{
            expect(testStruct.externalTemperature).to(equal(externalTemperature));
            expect(testStruct.cabinTemperature).to(equal(cabinTemperature));
            expect(testStruct.atmosphericPressure).to(equal(atmosphericPressure));
        });
    });

    context(@"allocate new struct and set it up", ^{
        SDLClimateData* testStruct = [[SDLClimateData alloc] init];
        testStruct.externalTemperature = externalTemperature;
        testStruct.cabinTemperature = cabinTemperature;
        testStruct.atmosphericPressure = atmosphericPressure;

        it(@"expect all properties to be equal to their initial values", ^{
            expect(testStruct.externalTemperature).to(equal(externalTemperature));
            expect(testStruct.cabinTemperature).to(equal(cabinTemperature));
            expect(testStruct.atmosphericPressure).to(equal(atmosphericPressure));
        });
    });

    context(@"allocate and init new struct with a dictionary", ^{
        NSDictionary *dict = @{
            SDLRPCParameterNameExternalTemperature: externalTemperature,
            SDLRPCParameterNameCabinTemperature: cabinTemperature,
            SDLRPCParameterNameAtmosphericPressure: atmosphericPressure,
        };
        SDLClimateData* testStruct = [[SDLClimateData alloc] initWithDictionary:dict];

        it(@"expect all properties to be equal to their initial values", ^{
            expect(testStruct.externalTemperature).to(equal(externalTemperature));
            expect(testStruct.cabinTemperature).to(equal(cabinTemperature));
            expect(testStruct.atmosphericPressure).to(equal(atmosphericPressure));
        });
    });
});

QuickSpecEnd
