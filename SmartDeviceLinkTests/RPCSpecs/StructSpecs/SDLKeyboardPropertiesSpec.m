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

describe(@"Getter/Setter Tests", ^ {
    __block SDLLanguage testLanguage = SDLLanguageDaDk;
    __block SDLKeyboardLayout testLayout = SDLKeyboardLayoutAZERTY;
    __block SDLKeypressMode testMode = SDLKeypressModeSingleKeypress;
    __block NSArray<NSString *> *testLimitedCharacterList = @[@"s", @"r", @"f"];
    __block NSString *testAutoCompleteText = @"Auto Carrot";
    __block NSArray<NSString *> *testAutoCompleteList = @[@"Hello World", @"How are you"];

    it(@"Should set and get correctly", ^ {
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

        expect(testStruct.language).to(equal(testLanguage));
        expect(testStruct.keyboardLayout).to(equal(testLayout));
        expect(testStruct.keypressMode).to(equal(testMode));
        expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
        expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
    });
    
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameLanguage: testLanguage,
                               SDLRPCParameterNameKeyboardLayout: testLayout,
                               SDLRPCParameterNameKeypressMode: testMode,
                               SDLRPCParameterNameLimitedCharacterList: testLimitedCharacterList,
                               SDLRPCParameterNameAutoCompleteList: testAutoCompleteList,
                               SDLRPCParameterNameAutoCompleteText: testAutoCompleteText
                            };
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] initWithDictionary:dict];

        expect(testStruct.language).to(equal(testLanguage));
        expect(testStruct.keyboardLayout).to(equal(testLayout));
        expect(testStruct.keypressMode).to(equal(testMode));
        expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
        expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
    });

    it(@"Should get correctly when initialized with initWithLanguage:layout:keypressMode:limitedCharacterList:autoCompleteText:autoCompleteList:", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLKeyboardProperties *testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage layout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteText:testAutoCompleteText autoCompleteList:testAutoCompleteList];
#pragma clang diagnostic pop
        expect(testStruct.language).to(equal(testLanguage));
        expect(testStruct.keyboardLayout).to(equal(testLayout));
        expect(testStruct.keypressMode).to(equal(testMode));
        expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.autoCompleteText).to(equal(testAutoCompleteText));
#pragma clang diagnostic pop
        expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
    });

    it(@"Should get correctly when initialized with initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList:", ^ {
        SDLKeyboardProperties *testStruct = [[SDLKeyboardProperties alloc] initWithLanguage:testLanguage keyboardLayout:testLayout keypressMode:testMode limitedCharacterList:testLimitedCharacterList autoCompleteList:testAutoCompleteList];
        expect(testStruct.language).to(equal(testLanguage));
        expect(testStruct.keyboardLayout).to(equal(testLayout));
        expect(testStruct.keypressMode).to(equal(testMode));
        expect(testStruct.limitedCharacterList).to(equal(testLimitedCharacterList));
        expect(testStruct.autoCompleteList).to(equal(testAutoCompleteList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
    });
    
    it(@"Should return nil if not set", ^ {
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] init];
        
        expect(testStruct.language).to(beNil());
        expect(testStruct.keyboardLayout).to(beNil());
        expect(testStruct.keypressMode).to(beNil());
        expect(testStruct.limitedCharacterList).to(beNil());
        expect(testStruct.autoCompleteList).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.autoCompleteText).to(beNil());
#pragma clang diagnostic pop
    });
});

QuickSpecEnd
