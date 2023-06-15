//
//  SDLLightControlDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLLightControlData.h"
#import "SDLRPCParameterNames.h"
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
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] initWithLightStates:[@[someLightState] copy]];
        expect(testStruct.lightState).to(equal([@[someLightState] copy]));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameLightState:[@[someLightState] copy]} mutableCopy];
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] initWithDictionary:dict];

        expect(testStruct.lightState).to(equal([@[someLightState] copy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] init];

        expect(testStruct.lightState).to(beNil());
    });
});

QuickSpecEnd
