//
//  SDLTTSChunkSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSpeechCapabilities.h"
#import "SDLTTSChunk.h"


QuickSpecBegin(SDLTTSChunkSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTTSChunk* testStruct = [[SDLTTSChunk alloc] init];
        
        testStruct.text = @"TEXT";
        testStruct.type = SDLSpeechCapabilitiesPrerecorded;
        
        expect(testStruct.text).to(equal(@"TEXT"));
        expect(testStruct.type).to(equal(SDLSpeechCapabilitiesPrerecorded));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameText:@"TEXT",
                                       SDLNameType:SDLSpeechCapabilitiesPrerecorded} mutableCopy];
        SDLTTSChunk* testStruct = [[SDLTTSChunk alloc] initWithDictionary:dict];
        
        expect(testStruct.text).to(equal(@"TEXT"));
        expect(testStruct.type).to(equal(SDLSpeechCapabilitiesPrerecorded));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTTSChunk* testStruct = [[SDLTTSChunk alloc] init];
        
        expect(testStruct.text).to(beNil());
        expect(testStruct.type).to(beNil());
    });
});

QuickSpecEnd
