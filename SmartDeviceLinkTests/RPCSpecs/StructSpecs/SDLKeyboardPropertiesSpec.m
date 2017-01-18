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

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] init];
        
        testStruct.language = SDLLanguageDaDk;
        testStruct.keyboardLayout = SDLKeyboardLayoutQWERTZ;
        testStruct.keypressMode = SDLKeypressModeResendCurrentEntry;
        testStruct.limitedCharacterList = [@[@"s", @"r", @"f", @"q"] mutableCopy];
        testStruct.autoCompleteText = @"Auto Carrot";
        
        expect(testStruct.language).to(equal(SDLLanguageDaDk));
        expect(testStruct.keyboardLayout).to(equal(SDLKeyboardLayoutQWERTZ));
        expect(testStruct.keypressMode).to(equal(SDLKeypressModeResendCurrentEntry));
        expect(testStruct.limitedCharacterList).to(equal([@[@"s", @"r", @"f", @"q"] mutableCopy]));
        expect(testStruct.autoCompleteText).to(equal(@"Auto Carrot"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameLanguage:SDLLanguageDaDk,
                                       SDLNameKeyboardLayout:SDLKeyboardLayoutQWERTZ,
                                       SDLNameKeypressMode:SDLKeypressModeResendCurrentEntry,
                                       SDLNameLimitedCharacterList:[@[@"s", @"r", @"f", @"q"] mutableCopy],
                                       SDLNameAutoCompleteText:@"Auto Carrot"} mutableCopy];
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] initWithDictionary:dict];
        
        expect(testStruct.language).to(equal(SDLLanguageDaDk));
        expect(testStruct.keyboardLayout).to(equal(SDLKeyboardLayoutQWERTZ));
        expect(testStruct.keypressMode).to(equal(SDLKeypressModeResendCurrentEntry));
        expect(testStruct.limitedCharacterList).to(equal([@[@"s", @"r", @"f", @"q"] mutableCopy]));
        expect(testStruct.autoCompleteText).to(equal(@"Auto Carrot"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] init];
        
        expect(testStruct.language).to(beNil());
        expect(testStruct.keyboardLayout).to(beNil());
        expect(testStruct.keypressMode).to(beNil());
        expect(testStruct.limitedCharacterList).to(beNil());
        expect(testStruct.autoCompleteText).to(beNil());
    });
});

QuickSpecEnd
