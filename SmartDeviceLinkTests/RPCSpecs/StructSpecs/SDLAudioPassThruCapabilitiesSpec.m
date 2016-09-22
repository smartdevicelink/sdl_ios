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
        
        testStruct.samplingRate = SDLSamplingRate22Khz;
        testStruct.bitsPerSample = SDLBitsPerSample8Bit;
        testStruct.audioType = SDLAudioTypePcm;
        
        expect(testStruct.samplingRate).to(equal(SDLSamplingRate22Khz));
        expect(testStruct.bitsPerSample).to(equal(SDLBitsPerSample8Bit));
        expect(testStruct.audioType).to(equal(SDLAudioTypePcm));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_samplingRate:SDLSamplingRate22Khz,
                                       NAMES_bitsPerSample:SDLBitsPerSample8Bit,
                                       NAMES_audioType:SDLAudioTypePcm} mutableCopy];
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.samplingRate).to(equal(SDLSamplingRate22Khz));
        expect(testStruct.bitsPerSample).to(equal(SDLBitsPerSample8Bit));
        expect(testStruct.audioType).to(equal(SDLAudioTypePcm));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] init];
        
        expect(testStruct.samplingRate).to(beNil());
        expect(testStruct.bitsPerSample).to(beNil());
        expect(testStruct.audioType).to(beNil());
    });
});

QuickSpecEnd
