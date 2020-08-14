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
    __block SDLTextFieldName testName = SDLTextFieldNameETA;
    __block SDLCharacterSet testCharacterSet = SDLCharacterSetUtf8;
    __block NSUInteger testWidth = 100;
    __block NSUInteger testRows = 4;

    it(@"Should set and get correctly", ^ {
        SDLTextField* testStruct = [[SDLTextField alloc] init];
        
        testStruct.name = testName;
        testStruct.characterSet = testCharacterSet;
        testStruct.width = @(testWidth);
        testStruct.rows = @(testRows);
        
        expect(testStruct.name).to(equal(testName));
        expect(testStruct.characterSet).to(equal(testCharacterSet));
        expect(testStruct.width).to(equal(@(testWidth)));
        expect(testStruct.rows).to(equal(@(testRows)));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameName:testName,
                               SDLRPCParameterNameCharacterSet:testCharacterSet,
                               SDLRPCParameterNameWidth:@(testWidth),
                               SDLRPCParameterNameRows:@(testRows)};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLTextField* testStruct = [[SDLTextField alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.name).to(equal(testName));
        expect(testStruct.characterSet).to(equal(testCharacterSet));
        expect(testStruct.width).to(equal(@(testWidth)));
        expect(testStruct.rows).to(equal(@(testRows)));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTextField* testStruct = [[SDLTextField alloc] init];
        
        expect(testStruct.name).to(beNil());
        expect(testStruct.characterSet).to(beNil());
        expect(testStruct.width).to(beNil());
        expect(testStruct.rows).to(beNil());
    });

    it(@"should initialize correctly with initWithName:characterSet:width:rows:", ^{
        SDLTextField *testStruct = [[SDLTextField alloc] initWithName:testName characterSet:testCharacterSet width:testWidth rows:testRows];

        expect(testStruct.name).to(equal(testName));
        expect(testStruct.characterSet).to(equal(testCharacterSet));
        expect(testStruct.width).to(equal(@(testWidth)));
        expect(testStruct.rows).to(equal(@(testRows)));
    });
});

QuickSpecEnd
