//
//  SDLTextFieldSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCharacterSet.h"
#import "SDLNames.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"


QuickSpecBegin(SDLTextFieldSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTextField* testStruct = [[SDLTextField alloc] init];
        
        testStruct.name = [SDLTextFieldName tertiaryText];
        testStruct.characterSet = [SDLCharacterSet TYPE5SET];
        testStruct.width = @111;
        testStruct.rows = @4;
        
        expect(testStruct.name).to(equal([SDLTextFieldName tertiaryText]));
        expect(testStruct.characterSet).to(equal([SDLCharacterSet TYPE5SET]));
        expect(testStruct.width).to(equal(@111));
        expect(testStruct.rows).to(equal(@4));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_name:[SDLTextFieldName tertiaryText],
                                       NAMES_characterSet:[SDLCharacterSet TYPE5SET],
                                       NAMES_width:@111,
                                       NAMES_rows:@4} mutableCopy];
        SDLTextField* testStruct = [[SDLTextField alloc] initWithDictionary:dict];
        
        expect(testStruct.name).to(equal([SDLTextFieldName tertiaryText]));
        expect(testStruct.characterSet).to(equal([SDLCharacterSet TYPE5SET]));
        expect(testStruct.width).to(equal(@111));
        expect(testStruct.rows).to(equal(@4));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTextField* testStruct = [[SDLTextField alloc] init];
        
        expect(testStruct.name).to(beNil());
        expect(testStruct.characterSet).to(beNil());
        expect(testStruct.width).to(beNil());
        expect(testStruct.rows).to(beNil());
    });
});

QuickSpecEnd