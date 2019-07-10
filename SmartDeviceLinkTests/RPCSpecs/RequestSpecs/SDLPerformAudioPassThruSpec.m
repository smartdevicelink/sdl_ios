//
//  SDLPerformAudioPassThruSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLPerformAudioPassThru.h"
#import "SDLSamplingRate.h"


QuickSpecBegin(SDLPerformAudioPassThruSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPerformAudioPassThru* testRequest = [[SDLPerformAudioPassThru alloc] init];
        
        testRequest.audioPassThruDisplayText1 = @"passthru#1";
        testRequest.audioPassThruDisplayText2 = @"passthru#2";
        testRequest.samplingRate = SDLSamplingRate22KHZ;
        testRequest.maxDuration = @34563;
        testRequest.bitsPerSample = SDLBitsPerSample16Bit;
        testRequest.audioType = SDLAudioTypePCM;
        testRequest.muteAudio = @NO;
        
        expect(testRequest.audioPassThruDisplayText1).to(equal(@"passthru#1"));
        expect(testRequest.audioPassThruDisplayText2).to(equal(@"passthru#2"));
        expect(testRequest.samplingRate).to(equal(SDLSamplingRate22KHZ));
        expect(testRequest.maxDuration).to(equal(@34563));
        expect(testRequest.bitsPerSample).to(equal(SDLBitsPerSample16Bit));
        expect(testRequest.audioType).to(equal(SDLAudioTypePCM));
        expect(testRequest.muteAudio).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameAudioPassThruDisplayText1:@"passthru#1",
                                                   SDLRPCParameterNameAudioPassThruDisplayText2:@"passthru#2",
                                                   SDLRPCParameterNameSamplingRate:SDLSamplingRate22KHZ,
                                                   SDLRPCParameterNameMaxDuration:@34563,
                                                   SDLRPCParameterNameBitsPerSample:SDLBitsPerSample16Bit,
                                                   SDLRPCParameterNameAudioType:SDLAudioTypePCM,
                                                   SDLRPCParameterNameMuteAudio:@NO},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNamePerformAudioPassThru}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLPerformAudioPassThru* testRequest = [[SDLPerformAudioPassThru alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.audioPassThruDisplayText1).to(equal(@"passthru#1"));
        expect(testRequest.audioPassThruDisplayText2).to(equal(@"passthru#2"));
        expect(testRequest.samplingRate).to(equal(SDLSamplingRate22KHZ));
        expect(testRequest.maxDuration).to(equal(@34563));
        expect(testRequest.bitsPerSample).to(equal(SDLBitsPerSample16Bit));
        expect(testRequest.audioType).to(equal(SDLAudioTypePCM));
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
