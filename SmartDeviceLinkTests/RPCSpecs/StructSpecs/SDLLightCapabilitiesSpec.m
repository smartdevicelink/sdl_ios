//
//  SDLLightCapabilitiesSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLLightName.h"
#import "SDLLightCapabilities.h"

QuickSpecBegin( SDLLightCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLLightCapabilities* testStruct = [[SDLLightCapabilities alloc] init];

        testStruct.name = SDLLightNameFogLights;
        testStruct.densityAvailable = @YES;
        testStruct.sRGBColorSpaceAvailable = @NO;

        expect(testStruct.name).to(equal(SDLLightNameFogLights));
        expect(testStruct.densityAvailable).to(equal(@YES));
        expect(testStruct.sRGBColorSpaceAvailable).to(equal(@NO));
    });

    it(@"Should set and get correctly", ^ {
        SDLLightCapabilities* testStruct = [[SDLLightCapabilities alloc] initWithName:SDLLightNameFogLights densityAvailable:YES sRGBColorSpaceAvailable:NO statusAvailable:NO];

        expect(testStruct.name).to(equal(SDLLightNameFogLights));
        expect(testStruct.densityAvailable).to(equal(@YES));
        expect(testStruct.sRGBColorSpaceAvailable).to(equal(@NO));
        expect(testStruct.statusAvailable).to(equal(@NO));

    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameName:SDLLightNameFogLights,
                                       SDLNameDensityAvailable:@YES,
                                       SDLNameRGBColorSpaceAvailable:@NO
                                       } mutableCopy];

        SDLLightCapabilities* testStruct = [[SDLLightCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.name).to(equal(SDLLightNameFogLights));
        expect(testStruct.densityAvailable).to(equal(@YES));
        expect(testStruct.sRGBColorSpaceAvailable).to(equal(@NO));
    });

    it(@"Should return nil if not set", ^ {
        SDLLightCapabilities* testStruct = [[SDLLightCapabilities alloc] init];

        expect(testStruct.name).to(beNil());
        expect(testStruct.densityAvailable).to(beNil());
        expect(testStruct.sRGBColorSpaceAvailable).to(beNil());

    });
});

QuickSpecEnd
