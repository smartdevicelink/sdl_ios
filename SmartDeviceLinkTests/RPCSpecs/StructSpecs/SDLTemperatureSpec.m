//
//  SDLTemperatureSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTemperature.h"
#import "SDLTemperatureUnit.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLTemperatureSpec)

describe(@"Initialization tests", ^{
    
    it(@"should properly initialize init", ^{
        SDLTemperature* testStruct = [[SDLTemperature alloc] init];
        
        expect(testStruct.unit).to(beNil());
        expect(testStruct.value).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLRPCParameterNameUnit : SDLTemperatureUnitCelsius ,
                                           SDLRPCParameterNameValue:@30 } mutableCopy];
        SDLTemperature* testStruct = [[SDLTemperature alloc] initWithDictionary:dict];
        
        expect(testStruct.unit).to(equal(SDLTemperatureUnitCelsius));
        expect(testStruct.value).to(equal(@30));
    });

    it(@"should initialize correctly with initWithUnit:value:", ^{
        SDLTemperature *testStruct = [[SDLTemperature alloc] initWithUnit:SDLTemperatureUnitCelsius value:30];

        expect(testStruct.unit).to(equal(SDLTemperatureUnitCelsius));
        expect(testStruct.value).to(equal(@30));
    });

    it(@"should initialize correctly with initWithFahrenheitValue:", ^{
        float fahrenheitValue = 22.121;
        SDLTemperature *testStruct = [[SDLTemperature alloc] initWithFahrenheitValue:fahrenheitValue];

        expect(testStruct.unit).to(equal(SDLTemperatureUnitFahrenheit));
        expect(testStruct.value).to(equal(fahrenheitValue));
    });

    it(@"should initialize correctly with initWithCelsiusValue:", ^{
        float celsiusValue = -40.2;
        SDLTemperature *testStruct = [[SDLTemperature alloc] initWithCelsiusValue:celsiusValue];

        expect(testStruct.unit).to(equal(SDLTemperatureUnitCelsius));
        expect(testStruct.value).to(equal(celsiusValue));
    });
    
    it(@"Should set and get correctly", ^{
        SDLTemperature* testStruct = [[SDLTemperature alloc] init];
        
        testStruct.unit = SDLTemperatureUnitCelsius;
        testStruct.value = @30;
        
        expect(testStruct.unit).to(equal(SDLTemperatureUnitCelsius));
        expect(testStruct.value).to(equal(@30));
    });
});

QuickSpecEnd
