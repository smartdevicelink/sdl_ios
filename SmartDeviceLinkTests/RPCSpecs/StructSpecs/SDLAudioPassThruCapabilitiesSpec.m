//
//  SDLAudioPassThruCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLAudioPassThruCapabilities.h"
#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLRPCParameterNames.h"
#import "SDLSamplingRate.h"


QuickSpecBegin(SDLAudioPassThruCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] init];
        
        testStruct.samplingRate = SDLSamplingRate22KHZ;
        testStruct.bitsPerSample = SDLBitsPerSample8Bit;
        testStruct.audioType = SDLAudioTypePCM;
        
        expect(testStruct.samplingRate).to(equal(SDLSamplingRate22KHZ));
        expect(testStruct.bitsPerSample).to(equal(SDLBitsPerSample8Bit));
        expect(testStruct.audioType).to(equal(SDLAudioTypePCM));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameSamplingRate:SDLSamplingRate22KHZ,
                                       SDLRPCParameterNameBitsPerSample:SDLBitsPerSample8Bit,
                                       SDLRPCParameterNameAudioType:SDLAudioTypePCM} mutableCopy];
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.samplingRate).to(equal(SDLSamplingRate22KHZ));
        expect(testStruct.bitsPerSample).to(equal(SDLBitsPerSample8Bit));
        expect(testStruct.audioType).to(equal(SDLAudioTypePCM));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] init];
        
        expect(testStruct.samplingRate).to(beNil());
        expect(testStruct.bitsPerSample).to(beNil());
        expect(testStruct.audioType).to(beNil());
    });
});

QuickSpecEnd
