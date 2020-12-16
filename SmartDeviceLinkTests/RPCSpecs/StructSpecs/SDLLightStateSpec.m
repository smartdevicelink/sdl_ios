//
//  SDLLightStateSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLightState.h"
#import "SDLLightStatus.h"
#import "SDLRGBColor.h"
#import "SDLLightName.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLLightStateSpec)

SDLRGBColor* someRGBColor = [[SDLRGBColor alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] init];

        testStruct.id = SDLLightNameFogLights;
        testStruct.status = SDLLightStatusOn;
        testStruct.density = @(0.5);
        testStruct.color = someRGBColor;

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOn));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.color).to(equal(someRGBColor));
    });

    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] initWithId:SDLLightNameFogLights status:SDLLightStatusOFF];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOFF));
        expect(testStruct.density).to(beNil());
        expect(testStruct.color).to(beNil());
    });

    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] initWithId:SDLLightNameFogLights status:SDLLightStatusOFF density:0.5 color:someRGBColor];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOFF));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.color).to(equal(someRGBColor));
    });

    it(@"Should set and get correctly", ^ {
        UIColor *testColorBack = [[UIColor alloc] init];
        SDLRGBColor *testBlack = [[SDLRGBColor alloc] initWithRed:0 green:0 blue:0];

        SDLLightState* testStruct = [[SDLLightState alloc] initWithId:SDLLightNameFogLights lightStatus:SDLLightStatusOFF lightDensity:0.5 lightColor:testColorBack];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOFF));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.color).to(equal(testBlack));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameId:SDLLightNameFogLights,
                                       SDLRPCParameterNameStatus:SDLLightStatusOn,
                                       SDLRPCParameterNameDensity:@(0.5),
                                       SDLRPCParameterNameColor:someRGBColor} mutableCopy];

        SDLLightState* testStruct = [[SDLLightState alloc] initWithDictionary:dict];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOn));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.color).to(equal(someRGBColor));
    });

    it(@"Should return nil if not set", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] init];

        expect(testStruct.id).to(beNil());
        expect(testStruct.status).to(beNil());
        expect(testStruct.density).to(beNil());
        expect(testStruct.color).to(beNil());
    });
});

QuickSpecEnd
