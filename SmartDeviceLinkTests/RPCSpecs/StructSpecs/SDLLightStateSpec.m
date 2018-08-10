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
#import "SDLNames.h"

QuickSpecBegin(SDLLightStateSpec)

SDLRGBColor* someRGBColor = [[SDLRGBColor alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] init];

        testStruct.id = SDLLightNameFogLights;
        testStruct.status = SDLLightStatusOn;
        testStruct.density = @(0.5);
        testStruct.RGBColor = someRGBColor;

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOn));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.RGBColor).to(equal(someRGBColor));
    });

    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] initWithId:SDLLightNameFogLights status:SDLLightStatusOFF];
        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOFF));
        expect(testStruct.density).to(beNil());
        expect(testStruct.RGBColor).to(beNil());

    });

    it(@"Should set and get correctly", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] initWithId:SDLLightNameFogLights status:SDLLightStatusOFF density:0.5 sRGBColor:someRGBColor];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOFF));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.RGBColor).to(equal(someRGBColor));

    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameId:SDLLightNameFogLights,
                                       SDLNameStatus:SDLLightStatusOn,
                                       SDLNameDensity:@(0.5),
                                       SDLNameRGBColor:someRGBColor} mutableCopy];

        SDLLightState* testStruct = [[SDLLightState alloc] initWithDictionary:dict];

        expect(testStruct.id).to(equal(SDLLightNameFogLights));
        expect(testStruct.status).to(equal(SDLLightStatusOn));
        expect(testStruct.density).to(equal(@(0.5)));
        expect(testStruct.RGBColor).to(equal(someRGBColor));

    });

    it(@"Should return nil if not set", ^ {
        SDLLightState* testStruct = [[SDLLightState alloc] init];

        expect(testStruct.id).to(beNil());
        expect(testStruct.status).to(beNil());
        expect(testStruct.density).to(beNil());
        expect(testStruct.RGBColor).to(beNil());
    });
});

QuickSpecEnd
