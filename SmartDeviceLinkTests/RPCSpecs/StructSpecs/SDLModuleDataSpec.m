//
//  SDLModuleDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLModuleData.h"
#import "SDLModuleType.h"
#import "SDLClimateControlData.h"
#import "SDLRadioControlData.h"
#import "SDLSeatControlData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLModuleDataSpec)

describe(@"Initialization tests", ^{
    __block SDLRadioControlData* someRadioData = [[SDLRadioControlData alloc] init];
    __block SDLClimateControlData* someClimateData = [[SDLClimateControlData alloc] init];
    __block SDLSeatControlData* someSeatData = [[SDLSeatControlData alloc] init];

    
    it(@"should properly initialize init", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];

        expect(testStruct.moduleType).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.seatControlData).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameModuleType:SDLModuleTypeRadio,
                                       SDLNameRadioControlData:someRadioData,
                                       SDLNameClimateControlData:someClimateData,
                                       SDLNameSeatControlData:someSeatData
                                       } mutableCopy];
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithDictionary:dict];
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.seatControlData).to(equal(someSeatData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
    });

    it(@"Should set and get correctly", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];
        testStruct.moduleType = SDLModuleTypeRadio;
        testStruct.radioControlData = someRadioData;
        testStruct.climateControlData = someClimateData;
        testStruct.seatControlData = someSeatData;
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.seatControlData).to(equal(someSeatData));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
    });

    it(@"Should get correctly when initialized with RadioControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithRadioControlData:someRadioData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.seatControlData).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithClimateControlData:someClimateData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testStruct.climateControlData).to(equal(someClimateData));
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.seatControlData).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithseatControlData:someSeatData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeSeat));
        expect(testStruct.seatControlData).to(equal(someSeatData));
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.climateControlData).to(beNil());
    });
});

QuickSpecEnd
