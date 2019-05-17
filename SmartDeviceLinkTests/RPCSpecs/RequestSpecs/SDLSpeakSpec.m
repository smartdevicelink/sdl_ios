//
//  SDLSpeakSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSpeak.h"
#import "SDLTTSChunk.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSpeakSpec)

SDLTTSChunk* chunk = [[SDLTTSChunk alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSpeak* testRequest = [[SDLSpeak alloc] init];
        
        testRequest.ttsChunks = [@[chunk] mutableCopy];
        
        expect(testRequest.ttsChunks).to(equal([@[chunk] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameTTSChunks:[@[chunk] mutableCopy]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameSpeak}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSpeak* testRequest = [[SDLSpeak alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.ttsChunks).to(equal([@[chunk] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSpeak* testRequest = [[SDLSpeak alloc] init];
        
        expect(testRequest.ttsChunks).to(beNil());
    });
});

QuickSpecEnd
