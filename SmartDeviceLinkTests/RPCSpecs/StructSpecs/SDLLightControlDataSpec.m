//
//  SDLLightControlDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLightControlData.h"
#import "SDLNames.h"
#import "SDLLightState.h"

QuickSpecBegin(SDLLightControlDataSpec)

SDLLightState* someLightState = [[SDLLightState alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] init];

        testStruct.lightState = [@[someLightState] copy];

        expect(testStruct.lightState).to(equal([@[someLightState] copy]));
    });

    it(@"Should set and get correctly", ^ {
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] initWithLightStateArray:[@[someLightState] copy]];
        expect(testStruct.lightState).to(equal([@[someLightState] copy]));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameLightState:[@[someLightState] copy]} mutableCopy];

        SDLLightControlData* testStruct = [[SDLLightControlData alloc] initWithDictionary:dict];

        expect(testStruct.lightState).to(equal([@[someLightState] copy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] init];

        expect(testStruct.lightState).to(beNil());
    });
});

QuickSpecEnd
