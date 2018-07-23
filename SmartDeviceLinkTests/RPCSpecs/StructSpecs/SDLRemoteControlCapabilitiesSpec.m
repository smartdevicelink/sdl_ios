//
//  SDLRemoteControlCapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioControlCapabilities.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLClimateControlCapabilities.h"
#import "SDLLightControlCapabilities.h"
#import "SDLHMISettingsControlCapabilities.h"
#import "SDLRadioControlCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLRemoteControlCapabilitiesSpec)

__block SDLClimateControlCapabilities* someClimateControlCapabilities = [[SDLClimateControlCapabilities alloc] init];
__block SDLRadioControlCapabilities* someRadioControlCapabilities = [[SDLRadioControlCapabilities alloc] init];
__block SDLButtonCapabilities* someButtonControlCapabilities = [[SDLButtonCapabilities alloc] init];

__block SDLAudioControlCapabilities* someAudioControlCapabilities = [[SDLAudioControlCapabilities alloc] init];

__block SDLLightControlCapabilities* someLightControlCapabilities = [[SDLLightControlCapabilities alloc] init];

__block SDLHMISettingsControlCapabilities* someHMISettingsControlCapabilities = [[SDLHMISettingsControlCapabilities alloc] init];


describe(@"Initialization tests", ^{
    it(@"should properly initialize init", ^{
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] init];
        
        expect(testStruct.climateControlCapabilities).to(beNil());
        expect(testStruct.radioControlCapabilities).to(beNil());
        expect(testStruct.buttonCapabilities).to(beNil());
        expect(testStruct.audioControlCapabilities).to(beNil());
        expect(testStruct.hmiSettingsControlCapabilities).to(beNil());
        expect(testStruct.lightControlCapabilities).to(beNil());

    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameClimateControlCapabilities : [@[someClimateControlCapabilities] copy],
                                       SDLNameRadioControlCapabilities :[@[someRadioControlCapabilities] copy],
                                       SDLNameButtonCapabilities :[@[someButtonControlCapabilities] copy],
                                       SDLNameAudioControlCapabilities :[@[someAudioControlCapabilities] copy],
                                       SDLNameLightControlCapabilities :[@[someLightControlCapabilities] copy],
                                       SDLNameHmiSettingsControlCapabilities : [@[someHMISettingsControlCapabilities] copy]
                                       } mutableCopy];
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.climateControlCapabilities).to(equal([@[someClimateControlCapabilities] copy]));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
        expect(testStruct.audioControlCapabilities).to(equal([@[someAudioControlCapabilities] copy]));
        expect(testStruct.hmiSettingsControlCapabilities).to(equal([@[someHMISettingsControlCapabilities] copy]));
        expect(testStruct.lightControlCapabilities).to(equal([@[someLightControlCapabilities] copy]));
    });
    
    it(@"Should set and get correctly", ^{
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] init];
        
        testStruct.climateControlCapabilities = ([@[someClimateControlCapabilities] copy]);
        testStruct.radioControlCapabilities = [@[someRadioControlCapabilities] copy];
        testStruct.buttonCapabilities = [@[someButtonControlCapabilities] copy];
        testStruct.audioControlCapabilities = [@[someAudioControlCapabilities] copy];
        testStruct.hmiSettingsControlCapabilities = [@[someHMISettingsControlCapabilities]copy];
        testStruct.lightControlCapabilities = [@[someLightControlCapabilities]copy];
        
        expect(testStruct.climateControlCapabilities).to(equal(([@[someClimateControlCapabilities] copy])));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
        expect(testStruct.audioControlCapabilities).to(equal([@[someAudioControlCapabilities] copy]));
        expect(testStruct.hmiSettingsControlCapabilities).to(equal([@[someHMISettingsControlCapabilities] copy]));
        expect(testStruct.lightControlCapabilities).to(equal([@[someLightControlCapabilities] copy]));
    });

    it(@"Should get correctly when initialized with climateControlCapabilities and other RemoteControlCapabilities parameters", ^ {
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] initWithClimateControlCapabilities:[@[someClimateControlCapabilities] copy] radioControlCapabilities:[@[someRadioControlCapabilities] copy] buttonCapabilities:[@[someButtonControlCapabilities] copy]];

        expect(testStruct.climateControlCapabilities).to(equal(([@[someClimateControlCapabilities] copy])));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
        expect(testStruct.audioControlCapabilities).to(beNil());
        expect(testStruct.hmiSettingsControlCapabilities).to(beNil());
        expect(testStruct.lightControlCapabilities).to(beNil());
    });

    it(@"Should get correctly when initialized with climateControlCapabilities and other RemoteControlCapabilities parameters", ^ {
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] initWithClimateControlCapabilities:[@[someClimateControlCapabilities] copy] radioControlCapabilities:[@[someRadioControlCapabilities] copy] buttonCapabilities:[@[someButtonControlCapabilities] copy]audioControlCapabilities:[@[someAudioControlCapabilities] copy] hmiSettingsControlCapabilities:[@[someHMISettingsControlCapabilities] copy] lightControlCapabilities:[@[someLightControlCapabilities] copy]];

        expect(testStruct.climateControlCapabilities).to(equal(([@[someClimateControlCapabilities] copy])));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
        expect(testStruct.audioControlCapabilities).to(equal([@[someAudioControlCapabilities] copy]));
        expect(testStruct.hmiSettingsControlCapabilities).to(equal([@[someHMISettingsControlCapabilities] copy]));
        expect(testStruct.lightControlCapabilities).to(equal([@[someLightControlCapabilities] copy]));
    });
});

QuickSpecEnd
