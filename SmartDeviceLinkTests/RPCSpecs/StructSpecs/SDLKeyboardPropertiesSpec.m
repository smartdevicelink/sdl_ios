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
#import "SDLNames.h"


QuickSpecBegin(SDLKeyboardPropertiesSpec)

describe(@"Keyboard Properties Tests", ^{
    __block SDLKeyboardProperties *testStruct = nil;
    __block SDLLanguage testLanguage = SDLLanguageDaDk;
    __block SDLKeyboardLayout testLayout = SDLKeyboardLayoutQWERTZ;
    __block SDLKeypressMode testKeypressMode = SDLKeypressModeSingleKeypress;
    __block NSArray<NSString *> *testLimitedCharacterSet = @[@"s", @"r", @"f", @"q"];
    __block NSArray<NSString *> *testAutocompleteList = @[@"Auto Carrot", @"hello"];

    describe(@"initializers", ^{
        it(@"should initialize with init", ^ {
            testStruct = [[SDLKeyboardProperties alloc] init];

            expect(testStruct.language).to(beNil());
            expect(testStruct.keyboardLayout).to(beNil());
            expect(testStruct.keypressMode).to(beNil());
            expect(testStruct.limitedCharacterList).to(beNil());
            expect(testStruct.autoCompleteText).to(beNil());
            expect(testStruct.autoCompleteList).to(beNil());
        });

        it(@"should initialize with initWithDictionary", ^ {
            NSDictionary *dict = @{SDLNameLanguage: testLanguage,
                                   SDLNameKeyboardLayout: testLayout,
                                   SDLNameKeypressMode: testKeypressMode,
                                   SDLNameLimitedCharacterList: testLimitedCharacterSet,
                                   SDLNameAutoCompleteText: testAutocompleteList[0],
                                   SDLNameAutoCompleteList: testAutocompleteList
                                   };
            testStruct = [[SDLKeyboardProperties alloc] initWithDictionary:dict];

            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testKeypressMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterSet));
            expect(testStruct.autoCompleteText).to(equal(testAutocompleteList[0]));
            expect(testStruct.autoCompleteList).to(equal(testAutocompleteList));
        });

        it(@"should initialize with initWithLanguage:layout:keypressMode:limitedCharacterList:autoCompleteText:", ^{
            testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage layout:testLayout keypressMode:testKeypressMode limitedCharacterList:testLimitedCharacterSet autoCompleteText:testAutocompleteList[0]];

            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testKeypressMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterSet));
            expect(testStruct.autoCompleteText).to(equal(testAutocompleteList[0]));
            expect(testStruct.autoCompleteList).to(beNil());
        });

        it(@"should initialize with initWithLanguage:layout:keypressMode:limitedCharacterList:autoCompleteText:autoCompleteList:", ^{
            testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage layout:testLayout keypressMode:testKeypressMode limitedCharacterList:testLimitedCharacterSet autoCompleteText:testAutocompleteList[0] autoCompleteList:testAutocompleteList];

            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(testLayout));
            expect(testStruct.keypressMode).to(equal(testKeypressMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterSet));
            expect(testStruct.autoCompleteText).to(equal(testAutocompleteList[0]));
            expect(testStruct.autoCompleteList).to(equal(testAutocompleteList));
        });
    });

    describe(@"getters and setters", ^{
        it(@"Should set and get correctly", ^ {
            testStruct = [[SDLKeyboardProperties alloc] init];

            testStruct.language = testLanguage;
            testStruct.keyboardLayout = testLayout;
            testStruct.keypressMode = testKeypressMode;
            testStruct.limitedCharacterList = testLimitedCharacterSet;
            testStruct.autoCompleteText = testAutocompleteList[0];
            testStruct.autoCompleteList = testAutocompleteList;

            expect(testStruct.language).to(equal(testLanguage));
            expect(testStruct.keyboardLayout).to(equal(SDLKeyboardLayoutQWERTZ));
            expect(testStruct.keypressMode).to(equal(testKeypressMode));
            expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterSet));
            expect(testStruct.autoCompleteText).to(equal(testAutocompleteList[0]));
            expect(testStruct.autoCompleteList).to(equal(testAutocompleteList));
        });
    });
});

QuickSpecEnd
