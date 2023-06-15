//
//  SDLKeyboardPropertiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLKeyboardInputMask.h"
#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLKeyboardProperties.h"
#import "SDLLanguage.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLKeyboardPropertiesSpec)

__block SDLLanguage testLanguage = nil;
__block SDLKeyboardLayout testLayout = nil;
__block SDLKeypressMode testMode = nil;
__block NSArray<NSString *> *testLimitedCharacterList = nil;
__block NSString *testAutoCompleteText = nil;
__block NSArray<NSString *> *testAutoCompleteList = nil;
__block SDLKeyboardInputMask maskInputCharacters = nil;
__block NSArray<NSString *> *customKeys = nil;
__block SDLKeyboardProperties* testStruct = nil;

describe(@"getter/setter tests", ^{
    beforeEach(^{
        testLanguage = SDLLanguageDaDk;
        testLayout = SDLKeyboardLayoutAZERTY;
        testMode = SDLKeypressModeSingleKeypress;
        testLimitedCharacterList = @[@"s", @"r", @"f"];
        testAutoCompleteText = @"Auto Carrot";
        testAutoCompleteList = @[@"Hello World", @"How are you"];
        maskInputCharacters = SDLKeyboardInputMaskEnableInputKeyMask;
        customKeys = @[@"abc", @"DEF"];
    });

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardProperties alloc] init];
        });

        it(@"expect all properties to be nil", ^{
            expect(testStruct.language).to(beNil());
            expect(testStruct.keyboardLayout).to(beNil());
            expect(testStruct.keypressMode).to(beNil());
            expect(testStruct.limitedCharacterList).to(beNil());
            expect(testStruct.autoCompleteList).to(beNil());
            expect(testStruct.maskInputCharacters).to(beNil());
            expect(testStruct.customKeys).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
        });
    });

    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardProperties alloc] init];
            testStruct.language = testLanguage;
            testStruct.keyboardLayout = testLayout;
            testStruct.keypressMode = testMode;
            testStruct.limitedCharacterList = testLimitedCharacterList;
            testStruct.autoCompleteList = testAutoCompleteList;
            testStruct.maskInputCharacters = maskInputCharacters;
            testStruct.customKeys = customKeys;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStruct.autoCompleteText = testAutoCompleteText;
#pragma clang diagnostic pop
            testStruct.maskInputCharacters = maskInputCharacters;
        });

        it(@"should be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(equal(maskInputCharacters));
            expect(testStruct.customKeys).to(equal(customKeys));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary* dict = @{SDLRPCParameterNameLanguage: testLanguage,
                                   SDLRPCParameterNameKeyboardLayout: testLayout,
                                   SDLRPCParameterNameKeypressMode: testMode,
                                   SDLRPCParameterNameLimitedCharacterList: testLimitedCharacterList,
                                   SDLRPCParameterNameAutoCompleteList: testAutoCompleteList,
                                   SDLRPCParameterNameAutoCompleteText: testAutoCompleteText,
                                   SDLRPCParameterNameMaskInputCharacters: maskInputCharacters,
                                   SDLRPCParameterNameCustomKeys: customKeys,
            };
            testStruct = [[SDLKeyboardProperties alloc] initWithDictionary:dict];
        });

        it(@"should be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(equal(maskInputCharacters));
            expect(testStruct.customKeys).to(equal(customKeys));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
        });
    });

    context(@"initWithLanguage:layout:keypressMode:limitedCharacterList:autoCompleteText:autoCompleteList:", ^{
        beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage layout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteText:testAutoCompleteText autoCompleteList:testAutoCompleteList];
#pragma clang diagnostic pop
        });

        it(@"should be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(beNil());
            expect(testStruct.customKeys).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
        });
    });

    context(@"initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList:", ^{
        beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage keyboardLayout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteList:testAutoCompleteList];
#pragma clang diagnostic pop
        });

        it(@"should be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(beNil());
            expect(testStruct.customKeys).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
        });
    });

    context(@"initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList:maskInputCharacters:customKeys:", ^{
        beforeEach(^{
            testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage keyboardLayout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteList:testAutoCompleteList maskInputCharacters:maskInputCharacters customKeys:customKeys];
        });

        it(@"should be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(equal(maskInputCharacters));
            expect(testStruct.customKeys).to(equal(customKeys));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
        });
    });
});

QuickSpecEnd
