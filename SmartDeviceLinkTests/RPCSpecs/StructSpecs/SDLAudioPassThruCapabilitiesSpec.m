//
//  SDLAudioPassThruCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAudioPassThruCapabilities* testStruct = [[SDLAudioPassThruCapabilities alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
