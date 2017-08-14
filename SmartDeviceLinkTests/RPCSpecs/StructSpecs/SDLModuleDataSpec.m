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
#import "SDLNames.h"

QuickSpecBegin(SDLModuleDataSpec)

describe(@"Initialization tests", ^{
    __block SDLRadioControlData* someRadioData = [[SDLRadioControlData alloc] init];
    __block SDLClimateControlData* someClimateData = [[SDLClimateControlData alloc] init];
    
    it(@"should properly initialize init", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];
        
        expect(testStruct.moduleType).to(beNil());
        expect(testStruct.radioControlData).to(beNil());
        expect(testStruct.climateControlData).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameModuleType:SDLModuleTypeRadio,
                                       SDLNameRadioControlData:someRadioData,
                                       SDLNameClimateControlData:someClimateData} mutableCopy];
        SDLModuleData* testStruct = [[SDLModuleData alloc] initWithDictionary:dict];
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
    });

    it(@"Should set and get correctly", ^{
        SDLModuleData* testStruct = [[SDLModuleData alloc] init];
        testStruct.moduleType = SDLModuleTypeRadio;
        testStruct.radioControlData = someRadioData;
        testStruct.climateControlData = someClimateData;
        
        expect(testStruct.moduleType).to(equal(SDLModuleTypeRadio));
        expect(testStruct.radioControlData).to(equal(someRadioData));
        expect(testStruct.climateControlData).to(equal(someClimateData));
    });
});

QuickSpecEnd
