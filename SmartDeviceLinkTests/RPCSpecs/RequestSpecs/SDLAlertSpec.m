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
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameAlertText1:@"alert#1",
                                                                   SDLNameAlertText2:@"alert#2",
                                                                   SDLNameAlertText3:@"alert#3",
                                                                   SDLNameTTSChunks:[@[tts] mutableCopy],
                                                                   SDLNameDuration:@4357,
                                                                   SDLNamePlayTone:@YES,
                                                                   SDLNameProgressIndicator:@NO,
                                                                   SDLNameSoftButtons:[@[button] mutableCopy]},
                                                             SDLNameOperationName:SDLNameAlert}} mutableCopy];
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

    it(@"Should handle NSNull", ^{
        NSMutableDictionary* dict = [@{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameAlertText1:@"alert#1",
                                                   SDLNameAlertText2:@"alert#2",
                                                   SDLNameAlertText3:@"alert#3",
                                                   SDLNameTTSChunks:[@[tts] mutableCopy],
                                                   SDLNameDuration:@4357,
                                                   SDLNamePlayTone:@YES,
                                                   SDLNameProgressIndicator:@NO,
                                                   SDLNameSoftButtons:[NSNull null]},
                                             SDLNameOperationName:SDLNameAlert}} mutableCopy];
        SDLAlert* testRequest = [[SDLAlert alloc] initWithDictionary:dict];

        expect(testRequest.softButtons).to(beEmpty());
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
