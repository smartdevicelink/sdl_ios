//
//  SDLAlertSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlert.h"
#import "SDLTTSChunk.h"
#import "SDLSoftButton.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAlertSpec)

SDLTTSChunk* tts = [[SDLTTSChunk alloc] init];
SDLSoftButton* button = [[SDLSoftButton alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAlert* testRequest = [[SDLAlert alloc] init];
        
        testRequest.alertText1 = @"alert#1";
        testRequest.alertText2 = @"alert#2";
        testRequest.alertText3 = @"alert#3";
        testRequest.ttsChunks = [@[tts] mutableCopy];
        testRequest.duration = @4357;
        testRequest.playTone = @YES;
        testRequest.progressIndicator = @NO;
        testRequest.softButtons = [@[button] mutableCopy];
        
        expect(testRequest.alertText1).to(equal(@"alert#1"));
        expect(testRequest.alertText2).to(equal(@"alert#2"));
        expect(testRequest.alertText3).to(equal(@"alert#3"));
        expect(testRequest.ttsChunks).to(equal([@[tts] mutableCopy]));
        expect(testRequest.duration).to(equal(@4357));
        expect(testRequest.playTone).to(equal(@YES));
        expect(testRequest.progressIndicator).to(equal(@NO));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_alertText1:@"alert#1",
                                                   NAMES_alertText2:@"alert#2",
                                                   NAMES_alertText3:@"alert#3",
                                                   NAMES_ttsChunks:[@[tts] mutableCopy],
                                                   NAMES_duration:@4357,
                                                   NAMES_playTone:@YES,
                                                   NAMES_progressIndicator:@NO,
                                                   NAMES_softButtons:[@[button] mutableCopy]},
                                             NAMES_operation_name:NAMES_Alert}} mutableCopy];
        SDLAlert* testRequest = [[SDLAlert alloc] initWithDictionary:dict];
        
        expect(testRequest.alertText1).to(equal(@"alert#1"));
        expect(testRequest.alertText2).to(equal(@"alert#2"));
        expect(testRequest.alertText3).to(equal(@"alert#3"));
        expect(testRequest.ttsChunks).to(equal([@[tts] mutableCopy]));
        expect(testRequest.duration).to(equal(@4357));
        expect(testRequest.playTone).to(equal(@YES));
        expect(testRequest.progressIndicator).to(equal(@NO));
        expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAlert* testRequest = [[SDLAlert alloc] init];
        
        expect(testRequest.alertText1).to(beNil());
        expect(testRequest.alertText2).to(beNil());
        expect(testRequest.alertText3).to(beNil());
        expect(testRequest.ttsChunks).to(beNil());
        expect(testRequest.duration).to(beNil());
        expect(testRequest.playTone).to(beNil());
        expect(testRequest.progressIndicator).to(beNil());
        expect(testRequest.softButtons).to(beNil());
    });
});

QuickSpecEnd