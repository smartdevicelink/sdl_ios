//
//  SDLRadioControlDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRadioControlData.h"
#import "SDLRadioBand.h"
#import "SDLRadioState.h"
#import "SDLRDSData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLRadioControlDataSpec)
__block SDLRDSData* someRdsData = [[SDLRDSData alloc] init];

describe(@"Initialization tests", ^{
    
    it(@"should properly initialize init", ^{
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] init];

        expect(testStruct.frequencyInteger).to(beNil());
        expect(testStruct.frequencyFraction).to(beNil());
        expect(testStruct.band).to(beNil());
        expect(testStruct.rdsData).to(beNil());
        expect(testStruct.availableHDs).to(beNil());
        expect(testStruct.hdChannel).to(beNil());
        expect(testStruct.signalStrength).to(beNil());
        expect(testStruct.signalChangeThreshold).to(beNil());
        expect(testStruct.radioEnable).to(beNil());
        expect(testStruct.state).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameFrequencyInteger : @101,
                                       SDLNameFrequencyFraction : @7,
                                       SDLNameBand : SDLRadioBandAM,
                                       SDLNameRDSData : someRdsData,
                                       SDLNameAvailableHDs : @2,
                                       SDLNameHDChannel : @2,
                                       SDLNameSignalStrength : @54,
                                       SDLNameSignalChangeThreshold : @76,
                                       SDLNameRadioEnable : @YES,
                                       SDLNameState : SDLRadioStateNotFound} mutableCopy];
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] initWithDictionary:dict];
        
        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.frequencyFraction).to(equal(@7));
        expect(testStruct.band).to(equal(SDLRadioBandAM));
        expect(testStruct.rdsData).to(equal(someRdsData));
        expect(testStruct.availableHDs).to(equal(@2));
        expect(testStruct.hdChannel).to(equal(@2));
        expect(testStruct.signalStrength).to(equal(@54));
        expect(testStruct.signalChangeThreshold).to(equal(@76));
        expect(testStruct.radioEnable).to(equal(@YES));
        expect(testStruct.state).to(equal(SDLRadioStateNotFound));
    });

    it(@"Should set and get correctly", ^{
        SDLRadioControlData* testStruct = [[SDLRadioControlData alloc] init];
        testStruct.frequencyInteger = @101;
        testStruct.frequencyFraction = @7;
        testStruct.band = SDLRadioBandAM;
        testStruct.rdsData = someRdsData;
        testStruct.availableHDs = @2;
        testStruct.hdChannel = @2;
        testStruct.signalStrength = @54;
        testStruct.signalChangeThreshold = @76;
        testStruct.radioEnable = @YES;
        testStruct.state = SDLRadioStateNotFound;
        
        expect(testStruct.frequencyInteger).to(equal(@101));
        expect(testStruct.frequencyFraction).to(equal(@7));
        expect(testStruct.band).to(equal(SDLRadioBandAM));
        expect(testStruct.rdsData).to(equal(someRdsData));
        expect(testStruct.availableHDs).to(equal(@2));
        expect(testStruct.hdChannel).to(equal(@2));
        expect(testStruct.signalStrength).to(equal(@54));
        expect(testStruct.signalChangeThreshold).to(equal(@76));
        expect(testStruct.radioEnable).to(equal(@YES));
        expect(testStruct.state).to(equal(SDLRadioStateNotFound));
    });
});

QuickSpecEnd
