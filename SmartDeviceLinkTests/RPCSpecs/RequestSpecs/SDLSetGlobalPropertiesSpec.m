//
//  SDLSetGlobalPropertiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLNames.h"
#import "SDLSetGlobalProperties.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"


QuickSpecBegin(SDLSetGlobalPropertiesSpec)

SDLTTSChunk* chunk1 = [[SDLTTSChunk alloc] init];
SDLTTSChunk* chunk2 = [[SDLTTSChunk alloc] init];
SDLVRHelpItem* help = [[SDLVRHelpItem alloc] init];
SDLImage* image = [[SDLImage alloc] init];
SDLKeyboardProperties* keyboard = [[SDLKeyboardProperties alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetGlobalProperties* testRequest = [[SDLSetGlobalProperties alloc] init];
        
        testRequest.helpPrompt = [@[chunk1] mutableCopy];
        testRequest.timeoutPrompt = [@[chunk2] mutableCopy];
        testRequest.vrHelpTitle = @"vr";
        testRequest.vrHelp = [@[help] mutableCopy];
        testRequest.menuTitle = @"TheNewMenu";
        testRequest.menuIcon = image;
        testRequest.keyboardProperties = keyboard;
        
        expect(testRequest.helpPrompt).to(equal([@[chunk1] mutableCopy]));
        expect(testRequest.timeoutPrompt).to(equal([@[chunk2] mutableCopy]));
        expect(testRequest.vrHelpTitle).to(equal(@"vr"));
        expect(testRequest.vrHelp).to(equal([@[help] mutableCopy]));
        expect(testRequest.menuTitle).to(equal(@"TheNewMenu"));
        expect(testRequest.menuIcon).to(equal(image));
        expect(testRequest.keyboardProperties).to(equal(keyboard));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameHelpPrompt:[@[chunk1] mutableCopy],
                                                                   SDLNameTimeoutPrompt:[@[chunk2] mutableCopy],
                                                                   SDLNameVRHelpTitle:@"vr",
                                                                   SDLNameVRHelp:[@[help] mutableCopy],
                                                                   SDLNameMenuTitle:@"TheNewMenu",
                                                                   SDLNameMenuIcon:image,
                                                                   SDLNameKeyboardProperties:keyboard},
                                                             SDLNameOperationName:SDLNameSetGlobalProperties}} mutableCopy];
        SDLSetGlobalProperties* testRequest = [[SDLSetGlobalProperties alloc] initWithDictionary:dict];
        
        expect(testRequest.helpPrompt).to(equal([@[chunk1] mutableCopy]));
        expect(testRequest.timeoutPrompt).to(equal([@[chunk2] mutableCopy]));
        expect(testRequest.vrHelpTitle).to(equal(@"vr"));
        expect(testRequest.vrHelp).to(equal([@[help] mutableCopy]));
        expect(testRequest.menuTitle).to(equal(@"TheNewMenu"));
        expect(testRequest.menuIcon).to(equal(image));
        expect(testRequest.keyboardProperties).to(equal(keyboard));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetGlobalProperties* testRequest = [[SDLSetGlobalProperties alloc] init];
        
        expect(testRequest.helpPrompt).to(beNil());
        expect(testRequest.timeoutPrompt).to(beNil());
        expect(testRequest.vrHelpTitle).to(beNil());
        expect(testRequest.vrHelp).to(beNil());
        expect(testRequest.menuTitle).to(beNil());
        expect(testRequest.menuIcon).to(beNil());
        expect(testRequest.keyboardProperties).to(beNil());
    });
});

QuickSpecEnd
