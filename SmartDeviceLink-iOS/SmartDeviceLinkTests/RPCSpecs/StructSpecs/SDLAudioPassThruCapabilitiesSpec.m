//
//  SDLAudioPassThruCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioPassThruCapabilities.h"
#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLNames.h"
#import "SDLSamplingRate.h"


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