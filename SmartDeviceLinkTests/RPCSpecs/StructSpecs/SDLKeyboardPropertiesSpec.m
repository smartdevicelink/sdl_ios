//
//  SDLKeyboardPropertiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardInputMask.h"
#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLKeyboardProperties.h"
#import "SDLLanguage.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLKeyboardPropertiesSpec)

describe(@"getter/setter tests", ^{
    SDLLanguage testLanguage = SDLLanguageDaDk;
    SDLKeyboardLayout testLayout = SDLKeyboardLayoutAZERTY;
    SDLKeypressMode testMode = SDLKeypressModeSingleKeypress;
    NSArray<NSString *> *testLimitedCharacterList = @[@"s", @"r", @"f"];
    NSString *testAutoCompleteText = @"Auto Carrot";
    NSArray<NSString *> *testAutoCompleteList = @[@"Hello World", @"How are you"];
    SDLKeyboardInputMask maskInputCharacters = SDLKeyboardInputMaskUserChoiceInputKeyMask;
    NSArray<NSString *> *customizeKeys = @[@"aaa", @"bbb"];

    context(@"init and assign", ^{
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] init];

        testStruct.language = testLanguage;
        testStruct.keyboardLayout = testLayout;
        testStruct.keypressMode = testMode;
        testStruct.limitedCharacterList = testLimitedCharacterList;
        testStruct.autoCompleteList = testAutoCompleteList;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testStruct.autoCompleteText = testAutoCompleteText;
#pragma clang diagnostic pop
        testStruct.maskInputCharacters = maskInputCharacters;
        testStruct.customizeKeys = customizeKeys;

        it(@"expect to be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
            expect(testStruct.maskInputCharacters).to(equal(maskInputCharacters));
            expect(testStruct.customizeKeys).to(equal(customizeKeys));
        });
    });

    context(@"initWithDictionary", ^{
        NSDictionary* dict = @{SDLRPCParameterNameLanguage: testLanguage,
                               SDLRPCParameterNameKeyboardLayout: testLayout,
                               SDLRPCParameterNameKeypressMode: testMode,
                               SDLRPCParameterNameLimitedCharacterList: testLimitedCharacterList,
                               SDLRPCParameterNameAutoCompleteList: testAutoCompleteList,
                               SDLRPCParameterNameAutoCompleteText: testAutoCompleteText,
                               SDLRPCParameterNameMaskInputCharacters: maskInputCharacters,
                               SDLRPCParameterNameCustomizeKeys: customizeKeys,
                            };
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] initWithDictionary:dict];

        it(@"expect to be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
            expect(testStruct.maskInputCharacters).to(equal(maskInputCharacters));
            expect(testStruct.customizeKeys).to(equal(customizeKeys));
        });
    });

    context(@"initWithLanguage:layout:keypressMode:limitedCharacterList:autoCompleteText:autoCompleteList:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLKeyboardProperties *testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage layout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteText:testAutoCompleteText autoCompleteList:testAutoCompleteList];
#pragma clang diagnostic pop

        it(@"expect to be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(beNil());
            expect(testStruct.customizeKeys).to(beNil());
        });
    });

    context(@"initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList:", ^{
        SDLKeyboardProperties *testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage keyboardLayout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteList:testAutoCompleteList];

        it(@"expect to be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(beNil());
            expect(testStruct.customizeKeys).to(beNil());
        });
    });

    context(@"initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList:maskInputCharacters:customizeKeys:", ^{
        SDLKeyboardProperties *testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage keyboardLayout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteList:testAutoCompleteList maskInputCharacters:maskInputCharacters customizeKeys:customizeKeys];

        it(@"expect to be set properly", ^{
            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
            expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
            expect(testStruct.maskInputCharacters).to(equal(maskInputCharacters));
            expect(testStruct.customizeKeys).to(equal(customizeKeys));
        });
    });

    context(@"init", ^{
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] init];

        it(@"should return nil if not set", ^{
            expect(testStruct.language).to(beNil());
            expect(testStruct.keyboardLayout).to(beNil());
            expect(testStruct.keypressMode).to(beNil());
            expect(testStruct.limitedCharacterList).to(beNil());
            expect(testStruct.autoCompleteList).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
            expect(testStruct.maskInputCharacters).to(beNil());
            expect(testStruct.customizeKeys).to(beNil());
        });
    });
});

QuickSpecEnd
