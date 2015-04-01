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
        
        testStruct.language = [SDLLanguage DA_DK];
        testStruct.keyboardLayout = [SDLKeyboardLayout QWERTZ];
        testStruct.keypressMode = [SDLKeypressMode RESEND_CURRENT_ENTRY];
        testStruct.limitedCharacterList = [@[@"s", @"r", @"f", @"q"] mutableCopy];
        testStruct.autoCompleteText = @"Auto Carrot";
        
        expect(testStruct.language).to(equal([SDLLanguage DA_DK]));
        expect(testStruct.keyboardLayout).to(equal([SDLKeyboardLayout QWERTZ]));
        expect(testStruct.keypressMode).to(equal([SDLKeypressMode RESEND_CURRENT_ENTRY]));
        expect(testStruct.limitedCharacterList).to(equal([@[@"s", @"r", @"f", @"q"] mutableCopy]));
        expect(testStruct.autoCompleteText).to(equal(@"Auto Carrot"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_language:[SDLLanguage DA_DK],
                                       NAMES_keyboardLayout:[SDLKeyboardLayout QWERTZ],
                                       NAMES_keypressMode:[SDLKeypressMode RESEND_CURRENT_ENTRY],
                                       NAMES_limitedCharacterList:[@[@"s", @"r", @"f", @"q"] mutableCopy],
                                       NAMES_autoCompleteText:@"Auto Carrot"} mutableCopy];
        SDLKeyboardProperties* testStruct = [[SDLKeyboardProperties alloc] initWithDictionary:dict];
        
        expect(testStruct.language).to(equal([SDLLanguage DA_DK]));
        expect(testStruct.keyboardLayout).to(equal([SDLKeyboardLayout QWERTZ]));
        expect(testStruct.keypressMode).to(equal([SDLKeypressMode RESEND_CURRENT_ENTRY]));
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