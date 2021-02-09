//
//  SDLKeyboardPropertiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLKeyboardProperties.h"
#import "SDLLanguage.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLKeyboardPropertiesSpec)

SDLLanguage testLanguage = SDLLanguageDaDk;
SDLKeyboardLayout testLayout = SDLKeyboardLayoutAZERTY;
SDLKeypressMode testMode = SDLKeypressModeSingleKeypress;
NSArray<NSString *> *testLimitedCharacterList = @[@"s", @"r", @"f"];
NSString *testAutoCompleteText = @"Auto Carrot";
NSArray<NSString *> *testAutoCompleteList = @[@"Hello World", @"How are you"];
SDLKeyboardInputMask maskInputCharacters = SDLKeyboardInputMaskEnableInputKeyMask;
NSArray<NSString *> *customKeys = @[@"abc", @"DEF"];

describe(@"getter/setter tests", ^{
    it(@"should set and get correctly", ^{
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] init];
        
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
    
    it(@"should get correctly when initialized with a dictionary", ^{
        NSDictionary* dict = @{SDLRPCParameterNameLanguage: testLanguage,
                               SDLRPCParameterNameKeyboardLayout: testLayout,
                               SDLRPCParameterNameKeypressMode: testMode,
                               SDLRPCParameterNameLimitedCharacterList: testLimitedCharacterList,
                               SDLRPCParameterNameAutoCompleteList: testAutoCompleteList,
                               SDLRPCParameterNameAutoCompleteText: testAutoCompleteText,
                               SDLRPCParameterNameMaskInputCharacters: maskInputCharacters,
                               SDLRPCParameterNameCustomKeys: customKeys,
                            };
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] initWithDictionary:dict];

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

    it(@"should get correctly when initialized with initWithLanguage:layout:keypressMode:limitedCharacterList:autoCompleteText:autoCompleteList:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLKeyboardProperties *testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage layout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteText:testAutoCompleteText autoCompleteList:testAutoCompleteList];
#pragma clang diagnostic pop
        expect(testStruct.language).to(equal(testLanguage));
        expect(testStruct.keyboardLayout).to(equal(testLayout));
        expect(testStruct.keypressMode).to(equal(testMode));
        expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
        expect(testStruct.maskInputCharacters).to(beNil());
        expect(testStruct.customKeys).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
        expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
    });

    it(@"should get correctly when initialized with initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLKeyboardProperties *testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage keyboardLayout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteList:testAutoCompleteList];
#pragma clang diagnostic pop
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
    
    it(@"should return nil if not set", ^{
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] init];
        
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

    context(@"initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList:maskInputCharacters:customKeys:", ^{
        __block SDLKeyboardProperties *testStruct = nil;

        beforeEach(^{
            testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage keyboardLayout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteList:testAutoCompleteList maskInputCharacters:maskInputCharacters customKeys:customKeys];
        });

        it(@"all properties must be set properly", ^{
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
