//
//  SDLLightStateSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLightState.h"
#import "SDLLightStatus.h"
#import "SDLSRGBColor.h"
#import "SDLLightName.h"
#import "SDLNames.h"

QuickSpecBegin(SDLLightStateSpec)

SDLSRGBColor* somesRGBColor = [[SDLSRGBColor alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] init];

        testStruct.id = SDLLightNameFogLights;
        testStruct.status = SDLLightStatusOn;
        testStruct.density = @(0.5);
        testStruct.sRGBColor = somesRGBColor;

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOn));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.sRGBColor).to(equal(somesRGBColor));
    });

    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] initWithID:SDLLightNameFogLights status:SDLLightStatusOFF];
        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOFF));
        expect(testStruct.density).to(beNil());
        expect(testStruct.sRGBColor).to(beNil());

    });

    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] initWithID:SDLLightNameFogLights status:SDLLightStatusOFF density:0.5 sRGBColor:somesRGBColor];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOFF));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.sRGBColor).to(equal(somesRGBColor));

    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameId:SDLLightNameFogLights,
                                       SDLNameStatus:SDLLightStatusOn,
                                       SDLNameDensity:@(0.5),
                                       SDLNameSRGBColor:somesRGBColor} mutableCopy];

        SDLLightState* testStruct = [[SDLLightState alloc] initWithDictionary:dict];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOn));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.sRGBColor).to(equal(somesRGBColor));

    });

    it(@"Should return nil if not set", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] init];

        expect(testStruct.id).to(beNil());
        expect(testStruct.status).to(beNil());
        expect(testStruct.density).to(beNil());
        expect(testStruct.sRGBColor).to(beNil());
    });
});

QuickSpecEnd
