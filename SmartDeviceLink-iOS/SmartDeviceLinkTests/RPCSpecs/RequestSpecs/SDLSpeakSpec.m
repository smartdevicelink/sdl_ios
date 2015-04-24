//
//  SDLSpeakSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSpeak.h"
#import "SDLTTSChunk.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSpeakSpec)

SDLTTSChunk* chunk = [[SDLTTSChunk alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSpeak* testRequest = [[SDLSpeak alloc] init];
        
        testRequest.ttsChunks = [@[chunk] mutableCopy];
        
        expect(testRequest.ttsChunks).to(equal([@[chunk] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_ttsChunks:[@[chunk] mutableCopy]},
                                             NAMES_operation_name:NAMES_Speak}} mutableCopy];
        SDLSpeak* testRequest = [[SDLSpeak alloc] initWithDictionary:dict];
        
        expect(testRequest.ttsChunks).to(equal([@[chunk] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSpeak* testRequest = [[SDLSpeak alloc] init];
        
        expect(testRequest.ttsChunks).to(beNil());
    });
});

QuickSpecEnd