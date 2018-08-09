//
//  SDLHMISettingsControlCapabilitiesSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMISettingsControlCapabilities.h"
#import "SDLNames.h"


QuickSpecBegin(SDLHMISettingsControlCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] init];

        testStruct.moduleName = @"displayMode";
        testStruct.distanceUnitAvailable = @(NO);
        testStruct.temperatureUnitAvailable = @(NO);
        testStruct.displayModeUnitAvailable = @(YES);

        expect(testStruct.moduleName).to(equal(@"displayMode"));
        expect(testStruct.distanceUnitAvailable).to(equal(@(NO)));
        expect(testStruct.temperatureUnitAvailable).to(equal(@(NO)));
        expect(testStruct.displayModeUnitAvailable).to(equal(@(YES)));
    });

    it(@"Should set and get correctly", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] initWithModuleName:@"displayMode"];

        expect(testStruct.moduleName).to(equal(@"displayMode"));
        expect(testStruct.distanceUnitAvailable).to(beNil());
        expect(testStruct.temperatureUnitAvailable).to(beNil());
        expect(testStruct.displayModeUnitAvailable).to(beNil());
    });

    it(@"Should set and get correctly", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] initWithModuleName:@"displayMode" distanceUnitAvailable:NO temperatureUnitAvailable:YES displayModeUnitAvailable:NO];

        expect(testStruct.moduleName).to(equal(@"displayMode"));
        expect(testStruct.distanceUnitAvailable).to(equal(@(NO)));
        expect(testStruct.temperatureUnitAvailable).to(equal(@(YES)));
        expect(testStruct.displayModeUnitAvailable).to(equal(@(NO)));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameModuleName:@"temperatureUnit",
                                       SDLNameTemperatureUnitAvailable:@(YES),
                                       SDLNameDistanceUnitAvailable:@(YES),
                                       SDLNameDisplayModeUnitAvailable:@(NO)
                                       } mutableCopy];
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(@"temperatureUnit"));
        expect(testStruct.distanceUnitAvailable).to(equal(@(YES)));
        expect(testStruct.temperatureUnitAvailable).to(equal(@(YES)));
        expect(testStruct.displayModeUnitAvailable).to(equal(@(NO)));

    });

    it(@"Should return nil if not set", ^ {
        SDLHMISettingsControlCapabilities* testStruct = [[SDLHMISettingsControlCapabilities alloc] init];

        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.distanceUnitAvailable).to(beNil());
        expect(testStruct.temperatureUnitAvailable).to(beNil());
        expect(testStruct.displayModeUnitAvailable).to(beNil());

    });
});

QuickSpecEnd
