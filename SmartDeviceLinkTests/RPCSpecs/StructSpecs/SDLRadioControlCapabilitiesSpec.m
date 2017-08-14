//
//  SDLRadioControlCapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRadioControlCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLRadioControlCapabilitiesSpec)

describe(@"Initialization tests", ^{
    
    it(@"should properly initialize init", ^{
        SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] init];
        
        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.radioEnableAvailable).to(beNil());
        expect(testStruct.radioBandAvailable).to(beNil());
        expect(testStruct.radioFrequencyAvailable).to(beNil());
        expect(testStruct.hdChannelAvailable).to(beNil());
        expect(testStruct.rdsDataAvailable).to(beNil());
        expect(testStruct.availableHDsAvailable).to(beNil());
        expect(testStruct.stateAvailable).to(beNil());
        expect(testStruct.signalStrengthAvailable).to(beNil());
        expect(testStruct.signalChangeThresholdAvailable).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameModuleName : @"someName",
                                       SDLNameRadioEnableAvailable : @YES,
                                       SDLNameRadioBandAvailable : @YES,
                                       SDLNameRadioFrequencyAvailable : @YES,
                                       SDLNameHdChannelAvailable : @NO,
                                       SDLNameRdsDataAvailable : @NO,
                                       SDLNameAvailableHDsAvailable : @NO,
                                       SDLNameStateAvailable : @YES,
                                       SDLNameSignalStrengthAvailable : @YES,
                                       SDLNameSignalChangeThresholdAvailable : @NO} mutableCopy];
        SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.moduleName).to(equal(@"someName"));
        expect(testStruct.radioEnableAvailable).to(equal(@YES));
        expect(testStruct.radioBandAvailable).to(equal(@YES));
        expect(testStruct.radioFrequencyAvailable).to(equal(@YES));
        expect(testStruct.hdChannelAvailable).to(equal(@NO));
        expect(testStruct.rdsDataAvailable).to(equal(@NO));
        expect(testStruct.availableHDsAvailable).to(equal(@NO));
        expect(testStruct.stateAvailable).to(equal(@YES));
        expect(testStruct.signalStrengthAvailable).to(equal(@YES));
        expect(testStruct.signalChangeThresholdAvailable).to(equal(@NO));
    });
    
    it(@"Should set and get correctly", ^{
        SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] init];
        
        testStruct.moduleName  = @"someName";
        testStruct.radioEnableAvailable = @YES;
        testStruct.radioBandAvailable = @YES;
        testStruct.radioFrequencyAvailable = @YES;
        testStruct.hdChannelAvailable = @NO;
        testStruct.rdsDataAvailable = @NO;
        testStruct.availableHDsAvailable = @NO;
        testStruct.stateAvailable = @YES;
        testStruct.signalStrengthAvailable = @YES;
        testStruct.signalChangeThresholdAvailable = @NO;
        
        expect(testStruct.moduleName).to(equal(@"someName"));
        expect(testStruct.radioEnableAvailable).to(equal(@YES));
        expect(testStruct.radioBandAvailable).to(equal(@YES));
        expect(testStruct.radioFrequencyAvailable).to(equal(@YES));
        expect(testStruct.hdChannelAvailable).to(equal(@NO));
        expect(testStruct.rdsDataAvailable).to(equal(@NO));
        expect(testStruct.availableHDsAvailable).to(equal(@NO));
        expect(testStruct.stateAvailable).to(equal(@YES));
        expect(testStruct.signalStrengthAvailable).to(equal(@YES));
        expect(testStruct.signalChangeThresholdAvailable).to(equal(@NO));
    });
});

QuickSpecEnd
