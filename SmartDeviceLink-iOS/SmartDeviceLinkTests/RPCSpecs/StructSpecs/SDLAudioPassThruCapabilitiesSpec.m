//
//  SDLAudioPassThruCapabilitiesSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioPassThruCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAudioPassThruCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] init];
        
        testStruct.samplingRate = [SDLSamplingRate _22KHZ];
        testStruct.bitsPerSample = [SDLBitsPerSample _8_BIT];
        testStruct.audioType = [SDLAudioType PCM];
        
        expect(testStruct.samplingRate).to(equal([SDLSamplingRate _22KHZ]));
        expect(testStruct.bitsPerSample).to(equal([SDLBitsPerSample _8_BIT]));
        expect(testStruct.audioType).to(equal([SDLAudioType PCM]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_samplingRate:[SDLSamplingRate _22KHZ],
                                       NAMES_bitsPerSample:[SDLBitsPerSample _8_BIT],
                                       NAMES_audioType:[SDLAudioType PCM]} mutableCopy];
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.samplingRate).to(equal([SDLSamplingRate _22KHZ]));
        expect(testStruct.bitsPerSample).to(equal([SDLBitsPerSample _8_BIT]));
        expect(testStruct.audioType).to(equal([SDLAudioType PCM]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] init];
        
        expect(testStruct.samplingRate).to(beNil());
        expect(testStruct.bitsPerSample).to(beNil());
        expect(testStruct.audioType).to(beNil());
    });
});

QuickSpecEnd