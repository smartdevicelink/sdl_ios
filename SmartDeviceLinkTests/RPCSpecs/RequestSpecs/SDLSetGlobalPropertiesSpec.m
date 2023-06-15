//
//  SDLSetGlobalPropertiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLMenuLayout.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSeatLocation.h"
#import "SDLSetGlobalProperties.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"


QuickSpecBegin(SDLSetGlobalPropertiesSpec)

NSString *menuTitle = @"TheNewMenu";
NSString *vrHelpTitle = @"vr";
NSString *helpTest = @"TheHelpText";
NSString *timeoutTest = @"timeout Test";
SDLTTSChunk *chunk1 = [[SDLTTSChunk alloc] initWithText:@"chunk 1" type:SDLSpeechCapabilitiesText];
SDLTTSChunk *chunk2 = [[SDLTTSChunk alloc] initWithText:@"chunk 2" type:SDLSpeechCapabilitiesText];
SDLVRHelpItem *help = [[SDLVRHelpItem alloc] init];
SDLImage *image = [[SDLImage alloc] init];
SDLKeyboardProperties *keyboard = [[SDLKeyboardProperties alloc] init];
SDLSeatLocation *seatLocation = [[SDLSeatLocation alloc] init];
SDLMenuLayout menuLayout = SDLMenuLayoutList;

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetGlobalProperties *testRequest = [[SDLSetGlobalProperties alloc] init];
        
        testRequest.helpPrompt = @[chunk1];
        testRequest.timeoutPrompt = @[chunk2];
        testRequest.vrHelpTitle = vrHelpTitle;
        testRequest.vrHelp = @[help];
        testRequest.menuTitle = menuTitle;
        testRequest.menuIcon = image;
        testRequest.keyboardProperties = keyboard;
        testRequest.userLocation = seatLocation;
        testRequest.menuLayout = menuLayout;
        
        expect(testRequest.helpPrompt).to(equal(@[chunk1]));
        expect(testRequest.timeoutPrompt).to(equal(@[chunk2]));
        expect(testRequest.vrHelpTitle).to(equal(@"vr"));
        expect(testRequest.vrHelp).to(equal(@[help]));
        expect(testRequest.menuTitle).to(equal(@"TheNewMenu"));
        expect(testRequest.menuIcon).to(equal(image));
        expect(testRequest.keyboardProperties).to(equal(keyboard));
        expect(testRequest.userLocation).to(equal(seatLocation));
        expect(testRequest.menuLayout).to(equal(menuLayout));
    });
    
    it(@"Should initialize correctly with a dictionary", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameHelpPrompt:@[chunk1],
                                           SDLRPCParameterNameTimeoutPrompt:@[chunk2],
                                           SDLRPCParameterNameVRHelpTitle:@"vr",
                                           SDLRPCParameterNameVRHelp:@[help],
                                           SDLRPCParameterNameMenuTitle:@"TheNewMenu",
                                           SDLRPCParameterNameUserLocation: seatLocation,
                                           SDLRPCParameterNameMenuIcon:image,
                                           SDLRPCParameterNameKeyboardProperties:keyboard,
                                           SDLRPCParameterNameMenuLayout:menuLayout
                                         },
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetGlobalProperties}};
        SDLSetGlobalProperties *testRequest = [[SDLSetGlobalProperties alloc] initWithDictionary:dict];

        expect(testRequest.helpPrompt).to(equal(@[chunk1]));
        expect(testRequest.timeoutPrompt).to(equal(@[chunk2]));
        expect(testRequest.vrHelpTitle).to(equal(vrHelpTitle));
        expect(testRequest.vrHelp).to(equal(@[help]));
        expect(testRequest.menuTitle).to(equal(menuTitle));
        expect(testRequest.menuIcon).to(equal(image));
        expect(testRequest.keyboardProperties).to(equal(keyboard));
        expect(testRequest.userLocation).to(equal(seatLocation));
        expect(testRequest.menuLayout).to(equal(menuLayout));
    });

    it(@"Should init correctly with initWithUserLocation:helpPrompt:timeoutPrompt:vrHelpTitle:vrHelp:menuTitle:menuIcon:keyboardProperties:menuLayout:", ^ {
        SDLSetGlobalProperties *testRequest = [[SDLSetGlobalProperties alloc] initWithUserLocation:seatLocation helpPrompt:[SDLTTSChunk textChunksFromString:helpTest] timeoutPrompt:[SDLTTSChunk textChunksFromString:timeoutTest] vrHelpTitle:vrHelpTitle vrHelp:@[help] menuTitle:menuTitle menuIcon:image keyboardProperties:keyboard menuLayout:menuLayout];

        expect(testRequest.helpPrompt).to(equal([SDLTTSChunk textChunksFromString:helpTest]));
        expect(testRequest.timeoutPrompt).to(equal([SDLTTSChunk textChunksFromString:timeoutTest]));
        expect(testRequest.vrHelpTitle).to(equal(vrHelpTitle));
        expect(testRequest.vrHelp).to(equal(@[help]));
        expect(testRequest.menuTitle).to(equal(menuTitle));
        expect(testRequest.menuIcon).to(equal(image));
        expect(testRequest.keyboardProperties).to(equal(keyboard));
        expect(testRequest.userLocation).to(equal(seatLocation));
        expect(testRequest.menuLayout).to(equal(menuLayout));
    });

    it(@"Should init correctly with initWithHelpText:timeoutText:vrHelpTitle:vrHelp:menuTitle:menuIcon:keyboardProperties:menuLayout:", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSetGlobalProperties *testRequest = [[SDLSetGlobalProperties alloc] initWithHelpText:helpTest timeoutText:timeoutTest vrHelpTitle:vrHelpTitle vrHelp:@[help] menuTitle:menuTitle menuIcon:image keyboardProperties:keyboard menuLayout:menuLayout];
#pragma clang diagnostic pop

        expect(testRequest.helpPrompt).to(equal([SDLTTSChunk textChunksFromString:helpTest]));
        expect(testRequest.timeoutPrompt).to(equal([SDLTTSChunk textChunksFromString:timeoutTest]));
        expect(testRequest.vrHelpTitle).to(equal(vrHelpTitle));
        expect(testRequest.vrHelp).to(equal(@[help]));
        expect(testRequest.menuTitle).to(equal(menuTitle));
        expect(testRequest.menuIcon).to(equal(image));
        expect(testRequest.keyboardProperties).to(equal(keyboard));
        expect(testRequest.userLocation).to(beNil());
        expect(testRequest.menuLayout).to(equal(menuLayout));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetGlobalProperties *testRequest = [[SDLSetGlobalProperties alloc] init];
        
        expect(testRequest.helpPrompt).to(beNil());
        expect(testRequest.timeoutPrompt).to(beNil());
        expect(testRequest.vrHelpTitle).to(beNil());
        expect(testRequest.vrHelp).to(beNil());
        expect(testRequest.menuTitle).to(beNil());
        expect(testRequest.menuIcon).to(beNil());
        expect(testRequest.keyboardProperties).to(beNil());
        expect(testRequest.userLocation).to(beNil());
        expect(testRequest.menuLayout).to(beNil());
    });
});

QuickSpecEnd
