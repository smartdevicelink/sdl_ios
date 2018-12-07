//  SDLHMISettingsControlDataSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMISettingsControlData.h"
#import "SDLNames.h"


QuickSpecBegin(SDLHMISettingsControlDataSpec)

describe(@"Getter/Setter Tests", ^ {
        it(@"Should set and get correctly", ^ {
            SDLHMISettingsControlData* testStruct = [[SDLHMISettingsControlData alloc] init];

            testStruct.displayMode = SDLDisplayModeAuto;
            testStruct.temperatureUnit = SDLTemperatureUnitCelsius;
            testStruct.distanceUnit = SDLDistanceUnitKilometers;

            expect(testStruct.displayMode).to(equal(SDLDisplayModeAuto));
            expect(testStruct.temperatureUnit).to(equal(SDLTemperatureUnitCelsius));
            expect(testStruct.distanceUnit).to(equal(SDLDistanceUnitKilometers));
        });

        it(@"Should set and get correctly", ^ {
            SDLHMISettingsControlData* testStruct = [[SDLHMISettingsControlData alloc] initWithDisplaymode:SDLDisplayModeAuto temperatureUnit:SDLTemperatureUnitCelsius distanceUnit:SDLDistanceUnitKilometers];

            expect(testStruct.displayMode).to(equal(SDLDisplayModeAuto));
            expect(testStruct.temperatureUnit).to(equal(SDLTemperatureUnitCelsius));
            expect(testStruct.distanceUnit).to(equal(SDLDistanceUnitKilometers));
        });

        it(@"Should get correctly when initialized", ^ {
            NSMutableDictionary* dict = [@{SDLNameDisplayMode:SDLDisplayModeAuto,
                                           SDLNameTemperatureUnit:SDLTemperatureUnitCelsius,
                                           SDLNameDistanceUnit:SDLDistanceUnitKilometers} mutableCopy];
            SDLHMISettingsControlData* testStruct = [[SDLHMISettingsControlData alloc] initWithDictionary:dict];

            expect(testStruct.displayMode).to(equal(SDLDisplayModeAuto));
            expect(testStruct.temperatureUnit).to(equal(SDLTemperatureUnitCelsius));
            expect(testStruct.distanceUnit).to(equal(SDLDistanceUnitKilometers));

        });

        it(@"Should return nil if not set", ^ {
            SDLHMISettingsControlData* testStruct = [[SDLHMISettingsControlData alloc] init];

            expect(testStruct.displayMode).to(beNil());
            expect(testStruct.temperatureUnit).to(beNil());
            expect(testStruct.distanceUnit).to(beNil());
        });
});

QuickSpecEnd
