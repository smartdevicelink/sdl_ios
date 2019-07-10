//
//  SDLTextFieldSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCharacterSet.h"
#import "SDLRPCParameterNames.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"


QuickSpecBegin(SDLTextFieldSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTextField* testStruct = [[SDLTextField alloc] init];
        
        testStruct.name = SDLTextFieldNameTertiaryText;
        testStruct.characterSet = SDLCharacterSetType5;
        testStruct.width = @111;
        testStruct.rows = @4;
        
        expect(testStruct.name).to(equal(SDLTextFieldNameTertiaryText));
        expect(testStruct.characterSet).to(equal(SDLCharacterSetType5));
        expect(testStruct.width).to(equal(@111));
        expect(testStruct.rows).to(equal(@4));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameName:SDLTextFieldNameTertiaryText,
                                       SDLRPCParameterNameCharacterSet:SDLCharacterSetType5,
                                       SDLRPCParameterNameWidth:@111,
                                       SDLRPCParameterNameRows:@4} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLTextField* testStruct = [[SDLTextField alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.name).to(equal(SDLTextFieldNameTertiaryText));
        expect(testStruct.characterSet).to(equal(SDLCharacterSetType5));
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
