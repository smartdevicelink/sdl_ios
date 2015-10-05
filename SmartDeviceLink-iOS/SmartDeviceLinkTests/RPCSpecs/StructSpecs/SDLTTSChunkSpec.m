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
        testStruct.type = [SDLSpeechCapabilities PRE_RECORDED];
        
        expect(testStruct.text).to(equal(@"TEXT"));
        expect(testStruct.type).to(equal([SDLSpeechCapabilities PRE_RECORDED]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_text:@"TEXT",
                                       NAMES_type:[SDLSpeechCapabilities PRE_RECORDED]} mutableCopy];
        SDLTTSChunk* testStruct = [[SDLTTSChunk alloc] initWithDictionary:dict];
        
        expect(testStruct.text).to(equal(@"TEXT"));
        expect(testStruct.type).to(equal([SDLSpeechCapabilities PRE_RECORDED]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTTSChunk* testStruct = [[SDLTTSChunk alloc] init];
        
        expect(testStruct.text).to(beNil());
        expect(testStruct.type).to(beNil());
    });
});

QuickSpecEnd