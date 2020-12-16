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
#import "SDLAudioControlData.h"
#import "SDLLightControlData.h"
#import "SDLHMISettingsControlData.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLModuleDataSpec)

describe(@"Initialization tests", ^{
    __block SDLRadioControlData* someRadioData = [[SDLRadioControlData alloc] init];
    __block SDLClimateControlData* someClimateData = [[SDLClimateControlData alloc] init];
    __block SDLAudioControlData* someAudioData = [[SDLAudioControlData alloc] init];
    __block SDLLightControlData* someLightData = [[SDLLightControlData alloc] init];
    __block SDLHMISettingsControlData* someHMISettingsData = [[SDLHMISettingsControlData alloc] init];
    __block SDLSeatControlData* someSeatData = [[SDLSeatControlData alloc] init];
    __block NSString *someModuleId = @"123";
    
    it(@"should properly initialize init", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];

        expect(testStruct.moduleType).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.seatControlData).to(beNil());
        expect(testStruct.audioControlData).to(beNil());
        expect(testStruct.hmiSettingsControlData).to(beNil());
        expect(testStruct.lightControlData).to(beNil());
        expect(testStruct.moduleId).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLRPCParameterNameModuleType:SDLModuleTypeRadio,
                                       SDLRPCParameterNameRadioControlData:someRadioData,
                                       SDLRPCParameterNameClimateControlData:someClimateData,
                                       SDLRPCParameterNameSeatControlData:someSeatData,
                                       SDLRPCParameterNameAudioControlData:someAudioData,
                                       SDLRPCParameterNameLightControlData:someLightData,
                                       SDLRPCParameterNameHmiSettingsControlData:someHMISettingsData,
                                       SDLRPCParameterNameModuleId:someModuleId} mutableCopy];
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithDictionary:dict];
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.seatControlData).to(equal(someSeatData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
        expect(testStruct.audioControlData).to(equal(someAudioData));
        expect(testStruct.hmiSettingsControlData).to(equal(someHMISettingsData));
        expect(testStruct.lightControlData).to(equal(someLightData));
        expect(testStruct.moduleId).to(equal(someModuleId));
    });

    it(@"Should set and get correctly", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];
        testStruct.moduleType = SDLModuleTypeRadio;
        testStruct.radioControlData = someRadioData;
        testStruct.climateControlData = someClimateData;
        testStruct.seatControlData = someSeatData;
        testStruct.audioControlData = someAudioData;
        testStruct.lightControlData = someLightData;
        testStruct.hmiSettingsControlData = someHMISettingsData;
        testStruct.moduleId = someModuleId;
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.seatControlData).to(equal(someSeatData));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
        expect(testStruct.audioControlData).to(equal(someAudioData));
        expect(testStruct.hmiSettingsControlData).to(equal(someHMISettingsData));
        expect(testStruct.lightControlData).to(equal(someLightData));
        expect(testStruct.moduleId).to(equal(someModuleId));
    });

    it(@"Should get correctly when initialized with RadioControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithRadioControlData:someRadioData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.seatControlData).to(beNil());
        expect(testStruct.moduleId).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithClimateControlData:someClimateData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testStruct.climateControlData).to(equal(someClimateData));
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.seatControlData).to(beNil());
        expect(testStruct.moduleId).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithSeatControlData:someSeatData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeSeat));
        expect(testStruct.seatControlData).to(equal(someSeatData));
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.moduleId).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithHMISettingsControlData:someHMISettingsData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeHMISettings));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.audioControlData).to(beNil());
        expect(testStruct.lightControlData).to(beNil());
        expect(testStruct.hmiSettingsControlData).to(equal(someHMISettingsData));
        expect(testStruct.moduleId).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithLightControlData:someLightData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeLight));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.audioControlData).to(beNil());
        expect(testStruct.lightControlData).to(equal(someLightData));
        expect(testStruct.hmiSettingsControlData).to(beNil());
        expect(testStruct.moduleId).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithAudioControlData:someAudioData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeAudio));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.audioControlData).to(equal(someAudioData));
        expect(testStruct.lightControlData).to(beNil());
        expect(testStruct.hmiSettingsControlData).to(beNil());
        expect(testStruct.moduleId).to(beNil());
    });
});

QuickSpecEnd
