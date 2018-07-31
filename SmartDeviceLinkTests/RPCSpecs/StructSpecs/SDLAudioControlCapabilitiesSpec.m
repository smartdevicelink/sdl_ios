//
//  SDLAudioControlCapabilitiesSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioControlCapabilities.h"
#import "SDLNames.h"


QuickSpecBegin( SDLAudioControlCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAudioControlCapabilities* testStruct = [[SDLAudioControlCapabilities alloc] init];

        testStruct.moduleName = @"module";
        testStruct.sourceAvailable = @(YES);
        testStruct.volumeAvailable = @(NO);
        testStruct.equalizerAvailable = @(NO);
        testStruct.equalizerMaxChannelId = @56;

        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.sourceAvailable).to(equal(@(YES)));
        expect(testStruct.volumeAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerMaxChannelId).to(equal(@56));
    });

    it(@"Should set and get correctly", ^ {
        SDLAudioControlCapabilities* testStruct = [[SDLAudioControlCapabilities alloc] initWithModuleName:@"module"];

        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.sourceAvailable).to(beNil());
        expect(testStruct.volumeAvailable).to(beNil());
        expect(testStruct.equalizerAvailable).to(beNil());
        expect(testStruct.equalizerMaxChannelId).to(beNil());
    });

    it(@"Should set and get correctly", ^ {
        SDLAudioControlCapabilities* testStruct = [[SDLAudioControlCapabilities alloc] initWithModuleName:@"module" sourceAvailable:@NO volueAvailable:@YES equalizerAvailable:@NO equalizerMaxChannelID:@34];

        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.sourceAvailable).to(equal(@(NO)));
        expect(testStruct.volumeAvailable).to(equal(@(YES)));
        expect(testStruct.equalizerAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerMaxChannelId).to(equal(@34));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameModuleName:@"module",
                                       SDLNameSourceAvailable:@(NO),
                                       SDLNameVolumeAvailable:@(YES),
                                       SDLNameEqualizerAvailable:@(NO),
                                       SDLNameEqualizerMaxChannelId:@12
                                       } mutableCopy];
        SDLAudioControlCapabilities* testStruct = [[SDLAudioControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.sourceAvailable).to(equal(@(NO)));
        expect(testStruct.volumeAvailable).to(equal(@(YES)));
        expect(testStruct.equalizerAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerMaxChannelId).to(equal(@12));

    });

    it(@"Should return nil if not set", ^ {
        SDLAudioControlCapabilities* testStruct = [[SDLAudioControlCapabilities alloc] init];

        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.sourceAvailable).to(beNil());
        expect(testStruct.volumeAvailable).to(beNil());
        expect(testStruct.equalizerAvailable).to(beNil());
        expect(testStruct.equalizerMaxChannelId).to(beNil());

    });
});

QuickSpecEnd
