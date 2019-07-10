//
//  SDLLightControlDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.lightState).to(equal([@[someLightState] copy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLLightControlData* testStruct = [[SDLLightControlData alloc] init];

        expect(testStruct.lightState).to(beNil());
    });
});

QuickSpecEnd
