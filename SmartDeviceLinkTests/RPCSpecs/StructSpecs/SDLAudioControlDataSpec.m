//
//  SDLAudioControlDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioControlData.h"
#import "SDLPrimaryAudioSource.h"
#import "SDLEqualizerSettings.h"
#import "SDLNames.h"


QuickSpecBegin( SDLAudioControlDataSpec)

SDLEqualizerSettings *someEqualizerSettings = [[SDLEqualizerSettings alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAudioControlData* testStruct = [[SDLAudioControlData alloc] init];

        testStruct.source = SDLPrimaryAudioSourceCD;
        testStruct.keepContext = @(NO);
        testStruct.volume = @(NO);
        testStruct.equalizerSettings = [@[someEqualizerSettings] copy];

        expect(testStruct.source).to(equal(SDLPrimaryAudioSourceCD));
        expect(testStruct.keepContext).to(equal(@(NO)));
        expect(testStruct.volume).to(equal(@(NO)));
        expect(testStruct.equalizerSettings).to(equal([@[someEqualizerSettings] copy]));
    });

    it(@"Should set and get correctly", ^ {
        SDLAudioControlData* testStruct = [[SDLAudioControlData alloc] initWithSource:SDLPrimaryAudioSourceCD keepContext:@(NO) volume:@32 equalizerSettings:[@[someEqualizerSettings] copy]];

        expect(testStruct.source).to(equal(SDLPrimaryAudioSourceCD));
        expect(testStruct.keepContext).to(equal(@(NO)));
        expect(testStruct.volume).to(equal(@32));
        expect(testStruct.equalizerSettings).to(equal([@[someEqualizerSettings] copy]));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameSource:SDLPrimaryAudioSourceCD,
                                       SDLNameKeepContext:@(NO),
                                       SDLNameVolume:@(NO),
                                       SDLNameEqualizerSettings:[@[someEqualizerSettings] copy]
                                       } mutableCopy];
        SDLAudioControlData* testStruct = [[SDLAudioControlData alloc] initWithDictionary:dict];

        expect(testStruct.source).to(equal(SDLPrimaryAudioSourceCD));
        expect(testStruct.keepContext).to(equal(@(NO)));
        expect(testStruct.volume).to(equal(@(NO)));
        expect(testStruct.equalizerSettings).to(equal([@[someEqualizerSettings] copy]));

    });

    it(@"Should return nil if not set", ^ {
        SDLAudioControlData* testStruct = [[SDLAudioControlData alloc] init];

        expect(testStruct.source).to(beNil());
        expect(testStruct.keepContext).to(beNil());
        expect(testStruct.volume).to(beNil());
        expect(testStruct.equalizerSettings).to(beNil());

    });
});

QuickSpecEnd
