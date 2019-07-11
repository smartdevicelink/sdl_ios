//
//  SDLAlertSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlert.h"
#import "SDLImage.h"
#import "SDLTTSChunk.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLAlertSpec)

SDLTTSChunk *tts = [[SDLTTSChunk alloc] init];
SDLSoftButton *button = [[SDLSoftButton alloc] init];
SDLImage *testImage = [[SDLImage alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAlert* testRequest = [[SDLAlert alloc] init];
        
        testRequest.alertText1 = @"alert#1";
        testRequest.alertText2 = @"alert#2";
        testRequest.alertText3 = @"alert#3";
        testRequest.ttsChunks = @[tts];
        testRequest.duration = @4357;
        testRequest.playTone = @YES;
        testRequest.progressIndicator = @NO;
        testRequest.softButtons = @[button];
        testRequest.alertIcon = testImage;
        
        expect(testRequest.alertText1).to(equal(@"alert#1"));
        expect(testRequest.alertText2).to(equal(@"alert#2"));
        expect(testRequest.alertText3).to(equal(@"alert#3"));
        expect(testRequest.ttsChunks).to(equal(@[tts]));
        expect(testRequest.duration).to(equal(@4357));
        expect(testRequest.playTone).to(equal(@YES));
        expect(testRequest.progressIndicator).to(equal(@NO));
        expect(testRequest.softButtons).to(equal(@[button]));
        expect(testRequest.alertIcon).to(equal(testImage));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameAlertText1: @"alert#1",
                                                                   SDLRPCParameterNameAlertText2: @"alert#2",
                                                                   SDLRPCParameterNameAlertText3: @"alert#3",
                                                                   SDLRPCParameterNameTTSChunks: @[tts],
                                                                   SDLRPCParameterNameDuration: @4357,
                                                                   SDLRPCParameterNamePlayTone: @YES,
                                                                   SDLRPCParameterNameProgressIndicator: @NO,
                                                                   SDLRPCParameterNameSoftButtons: @[button],
                                                                   SDLRPCParameterNameAlertIcon: testImage
                                                                   },
                                                             SDLRPCParameterNameOperationName: SDLRPCFunctionNameAlert
                                                             }
                                                      };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAlert* testRequest = [[SDLAlert alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
        NSMutableDictionary* dict = @{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameAlertText1: @"alert#1",
                                                   SDLRPCParameterNameAlertText2: @"alert#2",
                                                   SDLRPCParameterNameAlertText3: @"alert#3",
                                                   SDLRPCParameterNameTTSChunks: @[tts],
                                                   SDLRPCParameterNameDuration: @4357,
                                                   SDLRPCParameterNamePlayTone: @YES,
                                                   SDLRPCParameterNameProgressIndicator: @NO,
                                                   SDLRPCParameterNameSoftButtons: [NSNull null],
                                                   SDLRPCParameterNameAlertIcon: testImage
                                                   },
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameAlert}
                                      };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAlert* testRequest = [[SDLAlert alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        expectAction(^{
            NSArray<SDLSoftButton *> *softButtons = testRequest.softButtons;
        }).to(raiseException());
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
