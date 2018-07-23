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
#import "SDLAudioControlData.h"
#import "SDLLightControlData.h"
#import "SDLHMISettingsControlData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLModuleDataSpec)

describe(@"Initialization tests", ^{
    __block SDLRadioControlData* someRadioData = [[SDLRadioControlData alloc] init];
    __block SDLClimateControlData* someClimateData = [[SDLClimateControlData alloc] init];
    __block SDLAudioControlData* someAudioData = [[SDLAudioControlData alloc] init];
    __block SDLLightControlData* someLightData = [[SDLLightControlData alloc] init];
    __block SDLHMISettingsControlData* someHMISettingsData = [[SDLHMISettingsControlData alloc] init];

    it(@"should properly initialize init", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];
        
        expect(testStruct.moduleType).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.audioControlData).to(beNil());
        expect(testStruct.hmiSettingsControlData).to(beNil());
        expect(testStruct.lightControlData).to(beNil());

    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameModuleType:SDLModuleTypeRadio,
                                       SDLNameRadioControlData:someRadioData,
                                       SDLNameClimateControlData:someClimateData,
                                       SDLNameAudioControlData:someAudioData,
                                       SDLNameLightControlData:someLightData,
                                       SDLNameHmiSettingsControlData:someHMISettingsData} mutableCopy];
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithDictionary:dict];
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
        expect(testStruct.audioControlData).to(equal(someAudioData));
        expect(testStruct.hmiSettingsControlData).to(equal(someHMISettingsData));
        expect(testStruct.lightControlData).to(equal(someLightData));

    });

    it(@"Should set and get correctly", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];
        testStruct.moduleType = SDLModuleTypeRadio;
        testStruct.radioControlData = someRadioData;
        testStruct.climateControlData = someClimateData;
        testStruct.audioControlData = someAudioData;
        testStruct.lightControlData = someLightData;
        testStruct.hmiSettingsControlData = someHMISettingsData;
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
        expect(testStruct.audioControlData).to(equal(someAudioData));
        expect(testStruct.hmiSettingsControlData).to(equal(someHMISettingsData));
        expect(testStruct.lightControlData).to(equal(someLightData));
    });

    it(@"Should get correctly when initialized with RadioControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithRadioControlData:someRadioData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(beNil());

    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithClimateControlData:someClimateData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testStruct.climateControlData).to(equal(someClimateData));
        expect(testStruct.radioControlData).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithHMISettingsControlData:someHMISettingsData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeHMISettings));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.audioControlData).to(beNil());
        expect(testStruct.lightControlData).to(beNil());
        expect(testStruct.hmiSettingsControlData).to(equal(someHMISettingsData));
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithLightControlData:someLightData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeLight));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.audioControlData).to(beNil());
        expect(testStruct.lightControlData).to(equal(someLightData));
        expect(testStruct.hmiSettingsControlData).to(beNil());
    });

    it(@"Should get correctly when initialized with ClimateControlData", ^ {
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithAudioControlData:someAudioData];

        expect(testStruct.moduleType).to(equal(SDLModuleTypeAudio));
        expect(testStruct.climateControlData).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.audioControlData).to(equal(someAudioData));
        expect(testStruct.lightControlData).to(beNil());
        expect(testStruct.hmiSettingsControlData).to(beNil());
    });
});

QuickSpecEnd
