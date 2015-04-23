//
//  SDLPerformAudioPassThruSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLNames.h"
#import "SDLPerformAudioPassThru.h"
#import "SDLSamplingRate.h"


QuickSpecBegin(SDLPerformAudioPassThruSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPerformAudioPassThru* testRequest = [[SDLPerformAudioPassThru alloc] init];
        
        testRequest.audioPassThruDisplayText1 = @"passthru#1";
        testRequest.audioPassThruDisplayText2 = @"passthru#2";
        testRequest.samplingRate = [SDLSamplingRate _22KHZ];
        testRequest.maxDuration = @34563;
        testRequest.bitsPerSample = [SDLBitsPerSample _16_BIT];
        testRequest.audioType = [SDLAudioType PCM];
        testRequest.muteAudio = @NO;
        
        expect(testRequest.audioPassThruDisplayText1).to(equal(@"passthru#1"));
        expect(testRequest.audioPassThruDisplayText2).to(equal(@"passthru#2"));
        expect(testRequest.samplingRate).to(equal([SDLSamplingRate _22KHZ]));
        expect(testRequest.maxDuration).to(equal(@34563));
        expect(testRequest.bitsPerSample).to(equal([SDLBitsPerSample _16_BIT]));
        expect(testRequest.audioType).to(equal([SDLAudioType PCM]));
        expect(testRequest.muteAudio).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_audioPassThruDisplayText1:@"passthru#1",
                                                   NAMES_audioPassThruDisplayText2:@"passthru#2",
                                                   NAMES_samplingRate:[SDLSamplingRate _22KHZ],
                                                   NAMES_maxDuration:@34563,
                                                   NAMES_bitsPerSample:[SDLBitsPerSample _16_BIT],
                                                   NAMES_audioType:[SDLAudioType PCM],
                                                   NAMES_muteAudio:@NO},
                                             NAMES_operation_name:NAMES_PerformAudioPassThru}} mutableCopy];
        SDLPerformAudioPassThru* testRequest = [[SDLPerformAudioPassThru alloc] initWithDictionary:dict];
        
        expect(testRequest.audioPassThruDisplayText1).to(equal(@"passthru#1"));
        expect(testRequest.audioPassThruDisplayText2).to(equal(@"passthru#2"));
        expect(testRequest.samplingRate).to(equal([SDLSamplingRate _22KHZ]));
        expect(testRequest.maxDuration).to(equal(@34563));
        expect(testRequest.bitsPerSample).to(equal([SDLBitsPerSample _16_BIT]));
        expect(testRequest.audioType).to(equal([SDLAudioType PCM]));
        expect(testRequest.muteAudio).to(equal(@NO));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPerformAudioPassThru* testRequest = [[SDLPerformAudioPassThru alloc] init];
        
        expect(testRequest.audioPassThruDisplayText1).to(beNil());
        expect(testRequest.audioPassThruDisplayText2).to(beNil());
        expect(testRequest.samplingRate).to(beNil());
        expect(testRequest.maxDuration).to(beNil());
        expect(testRequest.bitsPerSample).to(beNil());
        expect(testRequest.audioType).to(beNil());
        expect(testRequest.muteAudio).to(beNil());
    });
});

QuickSpecEnd