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
        expect(testStruct.sisDataAvailable).to(beNil());

    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameModuleName : @"someName",
                                       SDLNameRadioEnableAvailable : @YES,
                                       SDLNameRadioBandAvailable : @YES,
                                       SDLNameRadioFrequencyAvailable : @YES,
                                       SDLNameHDChannelAvailable : @NO,
                                       SDLNameRDSDataAvailable : @NO,
                                       SDLNameAvailableHDsAvailable : @NO,
                                       SDLNameStateAvailable : @YES,
                                       SDLNameSignalStrengthAvailable : @YES,
                                       SDLNameSignalChangeThresholdAvailable : @NO,
                                       SDLNameSisDataAvailable:@YES
                                       } mutableCopy];
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
        expect(testStruct.sisDataAvailable).to(equal(@YES));

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
        testStruct.sisDataAvailable = @YES;
        
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
        expect(testStruct.sisDataAvailable).to(equal(@YES));

    });
    
    it(@"Should get correctly when initialized with Module Name and other radio control capabilite's parameters", ^ {
        SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] initWithModuleName:@"someName" radioEnableAvailable:YES radioBandAvailable:NO radioFrequencyAvailable:YES hdChannelAvailable:NO rdsDataAvailable:NO availableHDsAvailable:NO stateAvailable:YES signalStrengthAvailable:YES signalChangeThresholdAvailable:NO];

        expect(testStruct.moduleName).to(equal(@"someName"));
        expect(testStruct.radioEnableAvailable).to(equal(@YES));
        expect(testStruct.radioBandAvailable).to(equal(@NO));
        expect(testStruct.radioFrequencyAvailable).to(equal(@YES));
        expect(testStruct.hdChannelAvailable).to(equal(@NO));
        expect(testStruct.rdsDataAvailable).to(equal(@NO));
        expect(testStruct.availableHDsAvailable).to(equal(@NO));
        expect(testStruct.stateAvailable).to(equal(@YES));
        expect(testStruct.signalStrengthAvailable).to(equal(@YES));
        expect(testStruct.signalChangeThresholdAvailable).to(equal(@NO));
    });

    it(@"Should get correctly when initialized with Module Name and other radio control capabilite's parameters", ^ {
        SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] initWithModuleName:@"someName" radioEnableAvailable:YES radioBandAvailable:NO radioFrequencyAvailable:YES hdChannelAvailable:NO rdsDataAvailable:NO availableHDsAvailable:NO stateAvailable:YES signalStrengthAvailable:YES signalChangeThresholdAvailable:NO sisDataAvailable:YES];

        expect(testStruct.moduleName).to(equal(@"someName"));
        expect(testStruct.radioEnableAvailable).to(equal(@YES));
        expect(testStruct.radioBandAvailable).to(equal(@NO));
        expect(testStruct.radioFrequencyAvailable).to(equal(@YES));
        expect(testStruct.hdChannelAvailable).to(equal(@NO));
        expect(testStruct.rdsDataAvailable).to(equal(@NO));
        expect(testStruct.availableHDsAvailable).to(equal(@NO));
        expect(testStruct.stateAvailable).to(equal(@YES));
        expect(testStruct.signalStrengthAvailable).to(equal(@YES));
        expect(testStruct.signalChangeThresholdAvailable).to(equal(@NO));
        expect(testStruct.sisDataAvailable).to(equal(@YES));

    });
});

QuickSpecEnd
